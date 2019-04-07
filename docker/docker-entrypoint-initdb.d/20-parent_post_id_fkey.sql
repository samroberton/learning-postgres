alter table post
    add constraint post_parent_post_id_fkey foreign key (parent_post_id) references post(post_id);
