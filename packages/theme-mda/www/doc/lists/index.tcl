# create table order_lines (item_id integer, order_id integer, quantity integer, name varchar(300), price float);
# insert into order_lines values (1,1,100,'Apples', 10.2);
# insert into order_lines values (2,1,200,'Oranges', 20.3);
# insert into order_lines values (3,1,300,'Bananas', 30.4);
# insert into order_lines values (4,1,400,'Grapefruit', 40.5);
# insert into order_lines values(5,1,null,'Strawberry',1.6);

set order_id 1
#  display_eval {[lc_sepfmt [expr [expr [empty_string_p [string trim $quantity]]?0:$quantity] *$item_price]]}

template::list::create -name order_lines -multirow order_lines -key item_id -actions [list "Add item" [export_vars -base item-add {order_id}] "Add item to this order"] \
    -html [list summary "List of delicious fruits"] \
    -caption "Some delicious fruits?" \
    -bulk_actions {
	"Remove" "item-remove" "Remove checked items" 
	"Copy" "item-copy" "Copy checked items to clipboard" 
    }  -bulk_action_method post -bulk_action_export_vars {
	order_id
    } -row_pretty_plural "order items" -elements {
	quantity {
	    label "Quantity"
	}
	item_id {
	    label "Item"
	    display_col item_name
	    link_url_col item_url
	    link_html { title "View this item" }
	}
	item_price {
	    label "Price"
	    display_eval {[lc_sepfmt $item_price]}
	}
	extended_price {
	    label "Extended Price"
	    display_eval {[lc_sepfmt $item_price]}
	}
    }


db_multirow -extend { item_url } order_lines select_order_lines {
        select l.item_id,
               l.quantity,
               l.name as item_name,
               l.price as item_price
        from   order_lines l
        where  l.order_id = :order_id
} {
    set item_url [export_vars -base "item" { item_id }]
}