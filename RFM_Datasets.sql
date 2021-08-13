#---------RFM Model---------
select member.Member_Id,sum(order_item.Net_Amount) as Order_Sales,
count(distinct(order_info.Order_Id)) as Order_count ,
date_format(max(order_info.Create_Time),'%Y%m%d') as last_order
from (order_item
join order_info on order_info.order_id = order_item.order_id)
join member on member.Member_Id = order_info.Buyer_Id
where date_format(date_add(order_item.create_time,interval 8 hour),'%Y%m%d') between 20210101 and 20210630
and date_format(date_add(member.create_time,interval 8 hour),'%Y%m%d') between 20210101 and 20210630
#第一層資料過濾(針對訂單狀態篩選已成立的訂單)Filter established orders
and order_item.Order_Status in (1,2)
#第二層資料過濾(商品卡廠商)Filter two supplier which is no need
and order_item.Supp_Id not in (910,772)
#第三層資料過濾(去除團購會員)Filter some members who are like grouping type
and order_item.Buyer_Id not in (
select distinct(buyer_id) from order_item where Prod_Name like '%《團》%'
and order_status in (1,2))
group by member.Member_Id;


#---------New Customer purchased---------
select category.path,order_item.prod_id,prod_name,sum(order_item.Net_Amount),sum(Quantity) as Order_Sales
from (((order_item
join order_info on order_info.order_id = order_item.order_id)
join member on member.Member_Id = order_info.Buyer_Id)
join prod_category_mapping on prod_category_mapping.prod_id = order_item.prod_id)
join category on category.Category_Id = prod_category_mapping.Category_Id
where date_format(date_add(order_item.create_time,interval 8 hour),'%Y%m%d') between 20210101 and 20210630
and date_format(member.create_time + interval 8 hour,'%Y%m%d') between 20210101 and 20210630
#第一層資料過濾(針對訂單狀態篩選已成立的訂單) Filter established orders
and order_item.Order_Status in (1,2)
#第二層資料過濾(商品卡廠商) Filter two supplier which is no need 
and order_item.Supp_Id not in (910,772)
#第三層資料過濾(去除團購會員) Filter some members who are like grouping type
and order_item.Buyer_Id not in (
select distinct(buyer_id) from order_item where Prod_Name like '%《團》%'
and order_status in (1,2))
group by order_item.Prod_Id;

#---------cart_item_list by new customer who didn't purchase---------
select cart_item.prod_id,category.path,product.name,sum(cart_item.quantity),product.Enabled, 
	case 
		when product.Enabled = 1 then '上架'
		when product.Enabled = 0 then '下架'
		else 'null'
	end as '狀態'
from ((cart_item 
join cart on cart.cart_id = cart_item.cart_id)
join product on product.Prod_Id = cart_item.prod_id)
join category on category.Category_Id = product.category_id
where Member_Id in (
select member_id from member 
where date_format(date_add(member.create_time,interval 8 hour),'%Y%m%d') between 20210101 and 20210630
except
select buyer_id from order_info
where date_format(date_add(order_info.create_time,interval 8 hour),'%Y%m%d') between 20210101 and 20210630
)
group by cart_item.prod_id;






