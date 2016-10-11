<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<script type="text/javascript">

$(function(){
	$("input[name='gainPeopleNumType']").on('ifChecked', function(event){ 
		var $val=$(this).val();
		if($val==1){
			$("input[name='gainPeopleNum'][type='text']").attr("disabled","disabled");
			$("input[name='gainPeopleNum']").val("");
			$("#gainps").val("-1");
		}
		if($val==2){
			$("input[name='gainPeopleNum']").removeAttr("disabled");
		}
	});
	
	$("input[name='gainPeopleTimePurchaseNumType']").on('ifChecked', function(event){ 
		var $val=$(this).val();
		if($val==1){
			$("input[name='gainPeopleTimePurchaseNum'][type='text']").attr("disabled","disabled");
			$("input[name='gainPeopleTimePurchaseNum']").val("");
			$("#gainPeople").val("-1");
		}
		if($val==2){
			$("input[name='gainPeopleTimePurchaseNum']").removeAttr("disabled");
		}
	});
});

var $usefultemp=$("#useful_temp").html();
function initData(obj){
	$(obj).datepicker({
	    maxViewMode: 1,
	    format: 'mm-dd'
	}).on('show', function(event) {
	    event.preventDefault();
	    var datepicker = $(this).data('datepicker');
	    var switcher = datepicker.picker.find('.datepicker-switch').eq(0);
	    var year = datepicker.viewDate.getFullYear();
	    var text = switcher.text();
	    switcher.text( text.replace(year, '') );
	});
}
var obj=null;
$('[data-provider="select-all"]').selectAll();
//删除产品
function deleteProductPrice(object){
	$(object).parent().remove();
}

function delect_product_time(object){
	var len =$("div[name='useful_temp']").length;
	if(len > 1){
	  $(object).parent().parent().remove();
	}
}
//
function changeName(){
	var price = $("[name='marketPrice']").val();
	if(price != undefined)
		alert("修改产品组名称后请重新创建票型与结算价!");
	}
//选择景区
function createScenic(){
	var str ="";
	$(".scenic:checked").each(function(){
		str+="<li>"+$(this).attr('str')+"</li>";
		str+="<input type='hidden' str="+$(this).attr('str')+" value="+$(this).val()+" name='scenic'>";
	})
	$("#show_scenic").html(str);
	$("#scenic_div").modal('hide');
}
//选择景点
function createCheckInSite(){
	var str ="";
	$(".checkInSite:checked").each(function(){
		str+="<li>"+$(this).attr('str')+"</li>";
		str+="<input type='hidden' str="+$(this).attr('str')+" value="+$(this).val()+" name='checkInSite' match="+$(this).attr('match')+">";
	})
	$("#show_checkProduct").html(str);
	$("#jNumber").hide();
	var checkInSite=$("input[name=checkInSite][type=hidden]");
	for(var i=0;i<checkInSite.length;i++){
		var $this=$(checkInSite[i]).attr('match');
		if($this=="0"){
			$("#jNumber").show();
			break;
		}
	} 
	$("#checkInSit_div").modal('hide');
}
//演艺选择景点
function createCheckInSites(){
	var str ="";
	$(".checkInSite:checked").each(function(){
		str+="<li>"+$(this).attr('str')+"</li>";
		str+="<input type='hidden' str="+$(this).attr('str')+" value="+$(this).val()+" name='checkInSite' match="+$(this).attr('match')+">";
	})
	$("#show_checkProduct").html(str);
	$("#jNumber").hide();
	var checkInSite=$("input[name=checkInSite][type=hidden]");
	for(var i=0;i<checkInSite.length;i++){
		var $this=$(checkInSite[i]).attr('match');
		if($this=="0"){
			$("#jNumber").show();
			break;
		}
	} 
	$("#checkInSit_div").modal('hide');
//显示场次
	var scienicId =$("#show_scenic input[name=scenic]").val();
	var wrap = $('.screenings-count');
     if(scienicId==null||scienicId==""||scienicId==undefined)
	 { alert("请先选择景区"); 
	 return;
	 }
    var targetObjScree =$("span[name=screens]");
 	var matches=$(targetObjScree).next().val();
 	
 	$.ajax({
		type: "POST",
		url:path+"/product/getScreeList",
		data:{scienicId:scienicId},
		async: false,
 		dataType: "json",
		error: function(request) {
			alert("Connection error");
		},
		success: function(json) {
			if(json.state=='1'){
				var resultScree = json.data.screeCharList;
				var screeListStr = '';
			
				for(var i=0;i<resultScree.length;i++){
					if(resultScree[i].screeingsName==matches){
						screeListStr += '<label>'+
						'	<input type="radio" checked value="'+resultScree[i].screeingsName+'" str='+resultScree[i].screeingsName+' match="'+resultScree[i].screeingsName+'" name="matches" >'+resultScree[i].screeingsName+
						'</label>'	;
					}else{
						screeListStr += '<label>'+
						'	<input type="radio" value="'+resultScree[i].screeingsName+'" str='+resultScree[i].screeingsName+' match="'+resultScree[i].screeingsName+'" name="matches" >'+resultScree[i].screeingsName+
						'</label>';
					}
				}
				targetObjScree.html(screeListStr);
				wrap.find('input[type=checkbox]').iCheck();
				wrap.find('input[type=radio]').iCheck();
			}else {
				 alert(json.message);
				 $.MFT.pages.refreshTab(path+'/product/createProductPage?type='+10);
				
			}
		}
	});
}
//显示票型
var stockIndex = "";
function showTickType(obj,index){
	stockIndex= index;
	this.obj=obj;
	$("#ticket_type_div").modal('show');
}
//显示库存
var className = "";
function showStock(obj){
	$("#_add_stock_modal").modal('show');
	className= obj;
}
//查询库存
function selectStock(){
	var json = $("#select_stock_form").serialize();
	$.ajax({
		type:"POST",
		url:path+"/product/selectStock", 
		data:json,
		dataType:"html",
		success:function(data){
			$("#add_stock_channelList").html(data);
			$('#add_stock_channelList input').iCheck();
		},
		error:function(json){
			alert("网络忙，稍后再试");
		}
	});
}
	//选择库存
	function getSelectedStock(){
		var stock = $("input[name='stockRuleId']:checked");
		if(stock.val() == null || stock.val() == "" || stock.val() == "undefined"){
			alert("对不起，您还没有选择库存！");
		}else{
			$("#add_product_stockBox").html(stock.attr('str'));
			$("."+className+"").html(stock.attr('str'));
			$("."+className+"").attr("str",stock.val());
		}
		$("#_add_stock_modal").modal('hide');
	}
//当选择无确定库存时
	$("input[name='unlimitedInventory']").on("ifChecked",function(){
		var unlimitedInventory = $("input[name='unlimitedInventory']:checked").val();
		if(unlimitedInventory==1){
			$("#add_product_stockBox").html("");
		}
	
	});

//详情设置显示
function show_product_details(temp){
	$("#jNumber").hide();
	var checkInSite=$("input[name=checkInSite][type=hidden]");
	for(var i=0;i<checkInSite.length;i++){
		var $this=$(checkInSite[i]).attr('match');
		if($this=="0"){
			$("#jNumber").show();
			break;
		}
	} 
	$(temp).parent().parent().find("[name='newsletter']").toggle();
}


//根据景区ID选择场次 和区域信息
function show_product_detail(temp){
	var scienicId =$("#show_scenic input[name=scenic]").val();
	var targetObjScree = $(temp).parent().parent().find("[name='newsletter']").find("li[name=screeList] span.screeList");
	var targetObjArea =$("li[name=areaList] span.areaList");
	var matches=$(targetObjScree).next().val();
	var area =$(targetObjArea).next().val();
	var wrap = $('.flex-box-right');
     if(scienicId==null||scienicId==""||scienicId==undefined)
	 { alert("请先选择景区"); 
	 return;
	 }
     $("#jNumber").hide();
		var checkInSite=$("input[name=checkInSite][type=hidden]");
		for(var i=0;i<checkInSite.length;i++){
			var $this=$(checkInSite[i]).attr('match');
			if($this=="0"){
				$("#jNumber").show();
				break;
			}
		}
	$.ajax({
		type: "POST",
		url:path+"/product/getScreeList",
		data:{scienicId:scienicId},
		async: false,
 		dataType: "json",
		error: function(request) {
			alert("Connection error");
		},
		success: function(json) {
			if(json.state=='1'){
				$(temp).parent().parent().find("[name='newsletter']").toggle();
		 		var resultScree = json.data.screeCharList;
				var resultArea = json.data.areaCharList;
				var screeListStr = '';
				var areaListStr='';
			
				for(var i=0;i<resultScree.length;i++){
					if(resultScree[i].matches==matches){
						screeListStr += '<label class="label-checkbox mg-l-sm">'+
						'	<input type="checkbox" checked value="'+resultScree[i].matches+'" str="第'+resultScree[i].matches+'场" match="'+resultScree[i].matches+'" name="matches" >'+resultScree[i].matches+
						'场 </label>'	;
					}else{
						screeListStr += '<label class="label-checkbox mg-l-sm">'+
						'	<input type="checkbox" value="'+resultScree[i].matches+'" str="第'+resultScree[i].matches+'场" match="'+resultScree[i].matches+'" name="matches" >'+resultScree[i].matches+
						'场 </label>'	;
					}
				}
				for(var i=0;i<resultArea.length;i++){
					if(resultArea[i].area==area){
						areaListStr += '<label class="label-checkbox mg-l-sm">'+
						'	<input type="checkbox" checked value="'+resultArea[i].area+'" va="'+resultArea[i].areaDesc+'" str="'+resultArea[i].area+'"  name="area" >'+resultArea[i].areaDesc+
						'</label>'	;
					}else{
						areaListStr += '<label class="label-checkbox mg-l-sm">'+
						'	<input type="checkbox" value="'+resultArea[i].area+'" va="'+resultArea[i].areaDesc+'" str="'+resultArea[i].area+'"  name="area" >'+resultArea[i].areaDesc+
						'</label>'	;
					}	
				}
				targetObjScree.html(screeListStr);
				targetObjArea.html(areaListStr);
		        wrap.find('input[type=checkbox]').iCheck()
		        wrap.find(':checkbox').each(function(){
		       	 $(this).iCheck();
		       	 $(this).on("ifChanged", function(event){
		       		 var productStr="";
		       		 wrap.find('li[name=screeList] .screeList input[type=checkbox]:checked').each(function(){
		    		 var $matches=$(this);
		    		 wrap.find('li[name=areaList] .areaList input[type=checkbox]:checked').each(function(){
		         				var ticketType=$(this).attr("va")+$matches.attr("str");
		         				productStr+="<li>"
		         				productStr+="<span> 门票分类："+ticketType+"</span>"
		         				productStr+="<button type='button' str="+ticketType+"  area ="+$(this).val()+" matches="+$matches.val()+" class='btn btn-primary' onclick='showTickType(this)'>选择票型</button>"
		         				productStr+="</li>"
		         				productStr+="<ul class='box-list-nested' ></ul>"
		    				})
		    			})
		       	   $("div.flex-box-right[flag=product]").html(productStr);
		       	 });
		       	 
		        });
		        
			}else {
				 alert(json.message);
				 $.MFT.pages.refreshTab(path+'/product/createProductPage?type='+10);
				
			}
		}
	});
}
	//克隆模板2
function create_product_useful(){
	$("#save").before('<div class="panel panel-square" name="useful_temp" id="useful_temp"  >'+$usefultemp+'</div>');
 /*	$("#product_form").find("input[type='checkbox']").iCheck();
 		$("#save").find("input[type='radio']").iCheck(); */
}
//产品唯一性校验
function prese(){
	var name = "";
	name = $('.box-hide').find("[name='popularName']").val();
	var a = $('.screenings-count').find("input[name='matches']:checked").attr("str");
	if(a!=undefined){
		name = name+a;
	}
	if(name==""){
		alert("请输入产品组名称");
		return false;
	}
	$.ajax({
		type: "POST",
		url:path+"/product/checnNameOnlyOne",
		data:{name:name},
		async: false,
		error: function(request) {
			alert("参数解析错误");
		},
		success: function(data) {
			if(data.code==10001){
			 	alert(data.msg);
			 	return false;
			}else{
				checkProductTime();
			}
		}
	});	
}

/**
 * 校验产品有效期
 */
function checkProductTime(){
	var startDateTeam ="" ;
	var endDateTeam="" ;
	var vail = false;
	$(".create-list").find(".box-hide").each(function(){
		var startDate =$(this).find("[name='startDate']").val();
		var endDate =$(this).find("[name='endDate']").val();
		startDateTeam +=startDate+",";
		endDateTeam +=endDate+",";
		var sta = startDate.split("-");
		var start = (sta[0]+sta[1]).substr(0,4);
		var en = endDate.split("-");
		var end = (en[0]+en[1]).substr(0,4);
		if((end - start)<0){
			vail = true;
		}
	})

		 $.ajax({
			type: "POST",
			url:path+"/product/checkProductTime",
			data:{startDateTeam:startDateTeam,endDateTeam:endDateTeam},
			async: false,
			error: function(request) {
				alert("参数解析错误");
			},
			success: function(data) {
				if(vail){
					alert("产品有效期的结束时间不能小于产品的开始时间!!!");
					return false;
				}
				if(data.code==10001){
					$('.product_edit_tip_theater').modal('show');
					return false;
				}else if(data.code ==10002){
					$('.product_edit_tip_theater').modal('show');	
					return false;
				}else if(data.code ==10003){
					alert(data.message);
					return false;
				}else if(data.code ==10003){
					alert(data.message);
					return false;
				}else{
					confirms();
				}
			}
		}); 
}

//提交表单
function confirms(){
	var datas="";
	var flag= true;
	var productCategory =$("#productCategory").val();
	var scienicId =$("#show_scenic input[name=scenic]").val();
	//显示关闭时间
	var closeTime = "";
	var a = $(".calendar").find(".cell-close");
	for(var i=0;i<a.length;i++){
		var $this=$(a[i]).parent().attr('date');
		closeTime += $this+",";
	} 
	$(".create-list").find(".box-hide").each(function(){
		var str="";
		var name="";
		$(this).find("[name='name']").each(function(){
			name+=$(this).val()+","
		})
		var scenic="";
		var sceneName="";
		$(this).parents().find("[name='scenic']").each(function(){
			scenic +=$(this).val()+","
			sceneName +=$(this).attr('str')+",";
		})
		if(scenic==""){
			alert("景区不能为空");
			flag=false;
			return false;
		}
		var checkInSiteId="";
		var checkInSiteName="";
		var match="";
		$("input[name='checkInSite']").each(function(){
			checkInSiteId +=$(this).val()+","
			checkInSiteName +=$(this).attr('str')+",";
			match+=$(this).attr('match')+",";
		})
		if(checkInSiteId==""){
			alert("景点不能为空");
			flag=false;
		}
		var marketPrice="";
			$(this).find("[name='marketPrice']").each(function(){
			
			marketPrice+=$(this).val()+","
			})
			if(marketPrice==""){
				alert("请填写价格!");
				flag=false;
				return false;
			}
		var area ="";
		var matches ="";
		var ticketName="";
		if(productCategory=='10'){
			$(this).find("input[name='areass']").each(function(){
				area+=$(this).val()+","
			})
			$("input[name='matches']:checked").each(function(){
				matches =$(this).val();
			})
			$(this).find("[name='ticketName']").each(function(){
				ticketName+=$(this).val()+","
			})
			
		}
//入园方式
		var checkInType = $(this).find("input[name='checkInType']:checked").val();
//入园地址
		var checkinAddress = "";
		if(checkInType==2){
			checkinAddress =  $(this).find(".checkinAddress").val();
		}
		if(checkInType==1){
			checkinAddress =  $(this).find(".checkinAddres").val();
		}
		if(checkinAddress==""){
			alert("入园方式地址不能为空");
			flag=false;
			return false;
		}
		var stimeHour =$(this).parent().find("[name='stimeHour']").val();
		if(stimeHour ==""){
			alert("检票时间不能为空");
			flag=false;
			return false;
		}
		if(stimeHour >24){
			alert("请输入正确检票时间段!");
			flag=false;
			return false;
		}
		var simeMinutes =$(this).parent().find("[name='simeMinutes']").val();
		if(simeMinutes ==""){
			alert("检票时间不能为空");
			flag=false;
			return false;
		}
		if(simeMinutes >60){
			alert("请输入正确的检票时间段!");
			flag=false;
			return false;
		}
		var etimeHour =$(this).parent().find("[name='etimeHour']").val();
		if(etimeHour ==""){
			alert("检票时间不能为空");
			flag=false;
			return false;
		}
		if(etimeHour >24){
			alert("请输入正确检票时间段!");
			flag=false;
			return false;
		}
		var etimeMinutes =$(this).parent().find("[name='etimeMinutes']").val();
		if(etimeMinutes ==""){
			alert("检票时间不能为空");
			flag=false;
			return false;
		}
		if(etimeMinutes >60){
			alert("请输入正确检票时间段!");
			flag=false;
			return false;
		}
		var stime = (etimeHour+""+etimeMinutes)-(stimeHour+""+simeMinutes);
		if(stime<0){
			alert("检票时间段结束日期不能早于开始日期!");
			flag=false;
			return false;
		}
		var hour ="";
		var minutes ="";
		/* var hour =$(this).find("[name='hour']").val();
		if(hour ==""){
			alert("当日票最后购买日期不能为空");
			flag=false;
			return false;
		}
		if(hour >24){
			alert("请输入正确最后购买日期!");
			flag=false;
			return false;
		}
		
		var minutes =$(this).find("[name='minutes']").val();
		if(minutes ==""){
			alert("当日票最后购买日期截止时间不能为空");
			flag=false;
			return false;
		}
		if(hour >60){
			alert("请输入正确最后购买日期!");
			flag=false;
			return false;
		} */
		var startDate =$(this).parent().find("[name='startDate']").val();
		if(startDate ==""){
			alert("产品有限期不能为空");
			flag=false;
		}
		var endDate =$(this).parent().find("[name='endDate']").val();
		if(endDate ==""){
			alert("产品有限期不能为空");
			flag=false;
			return false;
		}
		var popularName =$(this).parent().find("[name='popularName']").val().trim();
		if(popularName ==""){
			alert("产品名称不能为空");
			flag=false;
			return false;
		}
		var match = $("input[name='matches']:checked").attr("str");
		if(productCategory=='10'){
			popularName = popularName+match;
		}
		
		var saleStartDate = $(this).find("[name='saleStartDate']").val();
		if(saleStartDate==""){
			alert("产品销售日期起始日期不能为空!");
			flag=false;
			return false;
		}
		var saleEndDate = $(this).find("[name='saleEndDate']").val();
		if(saleEndDate==""){
			alert("产品销售日期截止日期不能为空!");
			flag=false;
			return false;
		}
//取票人信息
		var gainType=$("input[name='gainType']:checked").val();
//同取票人数量
		var gainPeopleTimeLimitValue=$("input[name='gainPeopleTimeLimitValue']").val();
		if(gainPeopleTimeLimitValue==""){
	 		alert("同取票人领票时间范围数量请在1至9999的整数范围内填写。");
			flag=false;
			return false;
	 	}
//同取票人
		var gainPeopleTimeLimitUnit=$("select[name='gainPeopleTimeLimitUnit']").val();
//限购
		var gainPeopleTimePurchaseNumType=$("input[name='gainPeopleTimePurchaseNumType']:checked").val()
	 	var gainPeopleTimePurchaseNum="";
	 	if(gainPeopleTimePurchaseNumType==1){
	 		gainPeopleTimePurchaseNum="-1";
	 	}
	 	if(gainPeopleTimePurchaseNumType==2){
	 		gainPeopleTimePurchaseNum=$("input[name='gainPeopleTimePurchaseNum']").val()
		 	if(isNaN(gainPeopleTimePurchaseNum)){
				alert("同取票人领票时间范围值请输入数字！！");
				flag=false;
				return false;
			}
	 	}
//下单是否显示游玩时间
		var isNeedPlaytime = $(this).find("select[name='isNeedPlaytime']").val();
//游玩时间的值
		
		var noPlayTimetype = "";
//时间单位
		var timeUtils = "";
		var ordertimeValue="";
		if(isNeedPlaytime==0){
			noPlayTimetype = $(this).find("input[name='noPlayTimetype']:checked").val();
			if(noPlayTimetype!=1){
				ordertimeValue = $(this).find("input[name='ordertimeValue']").val();
				if(ordertimeValue==""){
					alert("游玩时间不能为空!");
					flag=false;
					return false;
				}
			timeUtils = $(this).find(".timeUtils").val();
			}
		}
		
		
		
		if(isNeedPlaytime==1){
			ordertimeValue = $(this).find("input[name='ordertimeValue']").val();
			if(ordertimeValue==""){
				alert("游玩时间不能为空!");
				flag=false;
				return false;
			}
			timeUtils = $(this).find(".timeUtil").val();
		}
//一句话特色
		var oneWordFeature = $(this).find("input[name='oneWordFeature']").val();
		if(oneWordFeature==""){
			alert("一句话特色不能为空!");
			flag=false;
			return false;
		}
//产品简介
		var introduce = $(this).find("textarea[name='reeaseInfo']").val();
		if(introduce==""){
			alert("产品简介不能为空!");
			flag=false;
			return false;
		}
//短信模板
		var smsTemplate =$(this).find("[name='smsTemplate']").val();
		if(smsTemplate ==""){
			alert("短信模板不能为空");
			flag=false;
			return false;
		}
//富文本的值产品详
	
		var text1 = tinyMCE.editors[0].getContent();
		
		
//预定须知
		var text2 = tinyMCE.editors[1].getContent();
		
//费用说明
		var text3 = tinyMCE.editors[2].getContent();
		
//销售技巧
		var text4 = tinyMCE.editors[3].getContent();
		
//重要条款
		var text5 = tinyMCE.editors[4].getContent();
		
//注意事项
		var text6 = tinyMCE.editors[5].getContent();
		
//使用方法
		var text7 = tinyMCE.editors[6].getContent();
//票的类型
		var ticketType="";
		$(this).find("[name='ticketType']").each(function(){
			ticketType+=$(this).val()+","
		})
//产品介绍
		var introduce =$(this).find("[name='introduce']").val();
		if(introduce ==""){
			alert("产品介绍不能为空");
			flag=false;
			return false;
		}
//图片信息
		var src="";
		var srcCheck = $(".create-list").find("[name='photoinfo']:checked").attr("src");	
		if(srcCheck == undefined){
			alert("请选择封面图片");
			flag=false;
			return false;
		}
		$(".create-list").find("[name='photoinfo']:checked").each(function(){
			src+=$(this).attr("src");
		})
		
		var srcs="";
		$(".create-list").find("[name='photoinfo']").each(function(){
			srcs+=$(this).attr("src")+","
		})
//库存状态
		var unlimitedInventory = "";
		var stockRuleId = "";
		if(productCategory=='10'){
		$(this).find("input[name='stockNumInd']").each(function(){
			stockRuleId +=$(this).val()+",";
			})
		}
		if(productCategory!='10'){
		unlimitedInventory = $("input[name='unlimitedInventory']:checked").val();
		if(unlimitedInventory==0){
			stockRuleId =$("input[name='stockRuleId']:checked").val();;
			}
		}
		str+= name+"#"+productCategory+"#"+popularName+"#"+marketPrice+"#";
		str+=hour+"#"+minutes+"#"+startDate+"#"+endDate+"#"+stimeHour+"#"+simeMinutes+"#"+etimeHour+"#"+etimeMinutes+"#";
		str+=saleStartDate+"#"+saleEndDate+"#"+closeTime+"#";
		str+=isNeedPlaytime+"#"+checkInType+"#"+checkinAddress+"#"+ordertimeValue+"#"+noPlayTimetype+"#"+timeUtils+"#";
		str+=scienicId+"#"+scenic+"#"+sceneName+"#"+checkInSiteId+"#"+checkInSiteName+"#";
		str+=area+"#"+matches+"#"+oneWordFeature+"#"+introduce+"#";
		str+=text1+"#"+text2+"#"+text3+"#"+text4+"#"+text5+"#"+text6+"#"+text7+"#"+ticketType+"#"+area+"#"+ticketName+"#";
		str+=src+"#"+srcs+"#"+smsTemplate+"#"+gainType+"#"+gainPeopleTimeLimitValue+"#"+gainPeopleTimeLimitUnit+"#"+gainPeopleTimePurchaseNumType+"#"+gainPeopleTimePurchaseNum+"#";
		str+=unlimitedInventory+"#"+stockRuleId+"#"+name+"#";
		datas+=str+";"
	})
	if(!flag)
		return;
	$.ajax({
		type: "POST",
		url:path+"/product/confirmProduct",
		contentType: "application/json;charset=UTF-8",
		data: JSON.stringify(datas),
		error: function(request) {
			alert("参数解析错误");
		},
		success: function(data) {
			 $('.product_edit_tip_theater').modal('hide');
			 alert(data.msg); 
			 $.MFT.pages.refreshTab(path+'/product/list?type='+productCategory);
		}
	});
}
function editPropertyProduct(){
	var aaa = "";
	var type=$("#productCategory").val();
	//显示关闭时间
	var closeTime = "";
	var a = $(".calendar").find(".cell-close");
	for(var i=0;i<a.length;i++){
		var $this=$(a[i]).parent().attr('date');
		closeTime += $this+",";
	} 
	var src="";
	$("input[name='photoinfo']:checked").each(function(){
		src+=$(this).attr("src");
	})
	
	var srcs="";
	$("input[name='photoinfo']").each(function(){
		srcs+=$(this).attr("src")+","
	})
	
	//检票开始时
	var stimeHour= $("input[name='stimeHour']").val();
	//检票开始分
	var simeMinutes = $("input[name='simeMinutes']").val();
	//检票结束时
	var etimeHour = $("input[name='etimeHour']").val();
	//检票结束分
	var etimeMinutes = $("input[name='etimeMinutes']").val();
	if(stimeHour == null || stimeHour == "" ||
			simeMinutes == null || simeMinutes == "" ||
			etimeHour == null || etimeHour == "" ||
			etimeMinutes == null || etimeMinutes == "" ){
		alert("检票时间段不可为空");
		return false;
	}
	if(stimeHour >23  || simeMinutes >60 || etimeHour > 23 || etimeMinutes > 60){
		alert("检票时间输入错误");
		return false;
	}
	var start = stimeHour * 60 + simeMinutes*1;
	var end = etimeHour * 60 + etimeMinutes*1;
	if(start >= end ){
		alert("检票结束日期必须大于开始日期");
		return false;
	}
	var startTime = stimeHour + ":" + simeMinutes;
	var endTime = etimeHour + ":" +etimeMinutes;
//富文本的值产品详情
		var text1 = tinyMCE.editors[0].getContent();
		
//预定须知
		var text2 = tinyMCE.editors[1].getContent();
		
//费用说明
		var text3 = tinyMCE.editors[2].getContent();
		
//销售技巧
		var text4 = tinyMCE.editors[3].getContent();
		
//重要条款
		var text5 = tinyMCE.editors[4].getContent();
		
//注意事项
		var text6 = tinyMCE.editors[5].getContent();
		
//使用方法
		var text7 = tinyMCE.editors[6].getContent();
		var jq = 0;
		aaa += jq+"#"+text1+"#"+text2+"#"+text3+"#"+text4+"#"+text5+"#"+text6+"#"+text7+"#"+jq+"#";
		$.ajax({
			type: "POST",
			url:path+"/product/editProductVo?closeTime="+closeTime+"&"+$("#editPropertyProduct").serialize()+"&src="+src+"&srcs="+srcs+"&startTime="+startTime+"&endTime="+endTime,
			contentType: "application/json;charset=UTF-8",
			data:JSON.stringify(aaa),
			error: function(request) {
				alert("参数解析错误");
			},
			success: function(data) {
				 alert(data.msg); 
				 $('.product_edit_tip_theater').modal('hide');
				 $.MFT.pages.refreshTab(path+'/product/list?type='+type);
			}
		});
} 

<c:if test="${type==1}">
//生成票种的价格
function createProductPrice(){
	$("#ticket_type_div").modal('hide');
 	var productName= $(obj).parent().parent().parent().parent().parent().parent().find("input[name='popularName']").val().trim();
	if(productName ==""){
		alert("请填写产品名称");
		return false;
		
	}
	var str="";
	$(".ticketType:checked").each(function(){
		var ticket_name =$(this).attr('str');
		str+="<li>";
		str+="票名:"+ticket_name+"";
		str+="<label class='mg-l-lg'>门市价<input type='text' name='marketPrice' class='form-control form-input-inline'></label>";
		str+="<input type='hidden' name='name' value="+productName+ticket_name+">";
		str+="<input type='hidden' name='ticketType' value="+$(this).val()+":"+$(this).attr('str')+">";
		str+="<button type='button' class='btn btn-primary btn-fixed-lg pull-right'  onclick='deleteProductPrice(this)' >删除</button>";
		str+="</li>";
	})
/* 	$("[type='hidden'][name='name']").val("");
	$("[type='hidden'][name='ticketType']").val("");
	$("[type='hidden'][name='ticketName']").val(""); */
	$("#price").hide();
	$(obj).parent().next().html(str);
}

$(function(){
    var wrap1 = $('.box-list');
    // 监听checkbox  ifClicked 点击
    wrap1.on('ifChanged', 'input:checkbox', function(e) {
    	
    });
})
</c:if>
<c:if test="${type==10 }">
//生成票种的价格
function createProductPrice(){

	$("#ticket_type_div").modal('hide');
	var productName=  $(obj).parent().parent().parent().parent().parent().parent().parent().parent().find("input[name='popularName']").val()
	if(productName ==""||productName == undefined){
		alert("请填写产品名称");
		return false;
	}
	
	inde = 0;
	var stockNumInd="";
	$("span[name='stockNames']").each(function(){
		if(inde==stockIndex){
			stockNumInd = $(this).attr("str");
		}
		inde++;
	}) 

	var str="";
	$(".ticketType:checked").each(function(){
	 	var ticket_name =$(this).attr('str');
	 	var isTicketName = productName+$(obj).attr('str')+$(this).attr('str'); 
		var ticketName =$(obj).attr('area')+"/"+$(obj).attr('matches')+"/";
		 
		str+="<li>";
		str+="票名:"+ticket_name+"";
		str+="<label class='mg-l-lg'>门市价<input type='text' name='marketPrice' class='form-control form-input-inline'></label>";
		str+="<input type='hidden' name='name' value="+isTicketName+">";
		str+="<input type='hidden' name='areass' value="+$(obj).attr('amcheid')+">";
		str+="<input type='hidden' name='matches' value="+$(obj).attr('matches')+">";
		str+="<input type='hidden' name='ticketName' value="+ticketName+">";
		str+="<input type='hidden' name='ticketType' value="+$(this).val()+":"+$(this).attr('str')+">";
		str+="<input type='hidden' name='stockNumInd' value="+stockNumInd+">";
		str+="<button class='btn btn-primary btn-fixed-lg pull-right'  onclick='deleteProductPrice(this)' >删除</button>";
		str+="</li>";
	})
	$(obj).parent().next().html(str);
}

//关闭时间的显示控件显示日期内所有的日期
Date.prototype.format=function (){
	var s='';
	s+=this.getFullYear()+'-';
	// 获取年份。
	s+=(this.getMonth()+1)+"-";         
	// 获取月份。
	s+= this.getDate();                 
	// 获取日。
	return(s);                          
	// 返回日期。
	};
//监听checkbox按钮监听事件

/*
 $(function(){
        var wrap1 = $('.box-list');
        // 监听checkbox  ifClicked 点击
        wrap1.on('ifChanged', 'input:checkbox', function(e) {
        	var $this=$(this).parent().parent().parent().parent();
        	var str="";
        			$this.find(".matches:checked").each(function(){
        				var $matches=$(this);
        				$this.find(".area:checked").each(function(){
             				var ticketType=$(this).attr("str")+$matches.attr("str");
             				str+="<li>"
             				str+="<span> 门票分类："+ticketType+"</span>"
             				str+="<button type='button' str="+ticketType+" area ="+$(this).val()+" matches="+$matches.val()+" class='btn btn-primary' onclick='showTickType(this)'>选择票型</button>"
             				str+="</li>"
             				str+="<ul class='box-list-nested' ></ul>"
        				})
        			})
        	/////////////////////////////parents会所有的全部替换
        	$(this).closest(".panel-square").find("[flag='product']").html(str);
        });
   })*/
</c:if>
$(document).ready(function(){
	var type = $("input[name='checkInType']:checked").val();
	if(type==1){
		$(".address").hide();
		$(".addres").show();
	}
	if(type==2){
		$(".addres").hide();
		$(".address").show();
	}
	
}); 
</script>
</head>

</html>