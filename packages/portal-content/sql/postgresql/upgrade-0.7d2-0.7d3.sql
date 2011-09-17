
-- Added resolution code to bt_content_actions

alter table bt_content_actions add column
  resolution                    varchar(50)
                                constraint bt_contents_resolution_ck
                                check (resolution is null or 
                                       resolution in ('fixed','bydesign','wontfix','postponed','duplicate','norepro'));
