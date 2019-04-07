begin;


create type badge_class as enum ('gold', 'silver', 'bronze');


create table badge (
    badge_id                    bigint primary key,
    se_user_id                  bigint not null references se_user(se_user_id),
    name                        text not null,
    date                        timestamptz not null,
    class                       badge_class not null,
    tag_based                   boolean not null
);


create function import_badges_file(filename text)
    returns void
as $$
    insert
      into badge ( badge_id,
                   se_user_id,
                   name,
                   date,
                   class,
                   tag_based
                 )
    select badge_id,
           se_user_id,
           name,
           date,
           case
             when class = 1 then 'gold' :: badge_class
             when class = 2 then 'silver'
             when class = 3 then 'bronze'
           end,
           tag_based
      from xmltable( '/badges/row'
                     passing (select xml (pg_read_file(filename, 0, 1000000000)))
                     columns
                         badge_id bigint path '@Id',
                         se_user_id bigint path '@UserId',
                         name text path '@Name',
                         date timestamptz path '@Date',
                         class integer path '@Class',
                         tag_based boolean path '@TagBased'
                   );
$$ language sql;


commit;
