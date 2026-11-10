create table if not exists public.favorites (
  owner_token uuid not null,
  pokemon_id integer not null check (pokemon_id between 1 and 151),
  created_at timestamptz not null default now(),
  primary key (owner_token, pokemon_id)
);

alter table public.favorites enable row level security;
revoke all on table public.favorites from anon, authenticated;

create or replace function public.list_my_favorites(p_owner_token uuid)
returns table (pokemon_id integer, created_at timestamptz)
language sql
stable
security definer
set search_path = ''
as $$
  select f.pokemon_id, f.created_at
  from public.favorites as f
  where f.owner_token = p_owner_token
  order by f.created_at desc;
$$;

create or replace function public.toggle_favorite(p_owner_token uuid, p_pokemon_id integer)
returns boolean
language plpgsql
volatile
security definer
set search_path = ''
as $$
declare
  rows_deleted integer;
begin
  if p_owner_token is null or p_pokemon_id not between 1 and 151 then
    raise exception 'Invalid owner token or Pokémon ID'
      using errcode = '22023';
  end if;

  perform pg_catalog.pg_advisory_xact_lock(
    pg_catalog.hashtextextended(p_owner_token::text, 0)
  );

  delete from public.favorites as f
  where f.owner_token = p_owner_token
    and f.pokemon_id = p_pokemon_id;

  get diagnostics rows_deleted = row_count;
  if rows_deleted > 0 then
    return false;
  end if;

  insert into public.favorites (owner_token, pokemon_id)
  values (p_owner_token, p_pokemon_id);

  return true;
end;
$$;

revoke all on function public.list_my_favorites(uuid) from public, anon, authenticated;
revoke all on function public.toggle_favorite(uuid, integer) from public, anon, authenticated;
grant execute on function public.list_my_favorites(uuid) to anon, authenticated;
grant execute on function public.toggle_favorite(uuid, integer) to anon, authenticated;
