begin;


create table se_user (
    se_user_id                  bigint primary key,
    reputation                  integer not null,
    display_name                text not null,
    last_access_date            timestamptz not null,
    website_url                 text,
    location                    text,
    about_me                    text,
    views                       bigint not null,
    up_votes                    bigint not null,
    down_votes                  bigint not null,
    profile_image_url           text,
    account_id                  bigint
);


create function import_users_file(filename text)
    returns void
as $$
    insert
      into se_user ( se_user_id,
                     reputation,
                     display_name,
                     last_access_date,
                     website_url,
                     location,
                     about_me,
                     views,
                     up_votes,
                     down_votes,
                     profile_image_url,
                     account_id
                   )
    select se_user_id,
           reputation,
           display_name,
           last_access_date,
           website_url,
           location,
           about_me,
           views,
           up_votes,
           down_votes,
           profile_image_url,
           account_id
      from xmltable( '/users/row'
                     passing (select xml (pg_read_file(filename, 0, 1000000000)))
                     columns
                         se_user_id bigint path '@Id',
                         reputation integer path '@Reputation',
                         creation_date timestamptz path '@CreationDate',
                         display_name text path '@DisplayName',
                         last_access_date timestamptz path '@LastAccessDate',
                         website_url text path '@WebsiteUrl',
                         location text path '@Location',
                         about_me text path '@AboutMe',
                         views bigint path '@Views',
                         up_votes bigint path '@UpVotes',
                         down_votes bigint path '@DownVotes',
                         profile_image_url text path '@ProfileImageUrl',
                         account_id bigint path '@AccountId'
                   );
$$ language sql;


commit;
