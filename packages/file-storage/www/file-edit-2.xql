<?xml version="1.0" ?>

<queryset>

<fullquery name="edit_title">
    <querytext>
        update cr_revisions set title=:title
	where revision_id=(select live_revision from cr_items
                           where item_id=:file_id)
    </querytext>
</fullquery>
</queryset>