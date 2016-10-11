<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglibs.jsp"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<style type="text/css">
    .isvisible {水电费
        visibility: hidden;
        display: inline-block;
    }    
    .lock-isvisible {
        visibility: visible;
        display: inline-block;
    }
    .j_item,.j_batch {
        display: none;
    }

    #lock_modal form {
        display: none;
    }

    #lock_modal .form1 .list-horizontal {
        display: none;
    }
sdfadsfdasfds
</style>
<style>
.calendar {
    margin: 0 auto;
    font-family: "微软雅黑";
}

.fc .fc-header-column {
    padding: 1px 0;
}

.fc-toolbar {
    text-align: center;
    border: 1px solid #ddd;
    border-bottom: 0;
    margin-bottom: 0;
}

.fc-button.disabled {
    background-color: #fff;
}

.fc-button {
    background-color: #fff;
    border: none;
}

.fc {
    width: 582px;
}

.fc-header {
    border-left: 1px solid #ddd;
    border-right: 1px solid #ddd;
}

.fc-header th {
    width: 83px;
    height: 28px;
}


/*.fc-close {
            position: absolute;
            bottom: 8px;
            right: 8px;
            color: #fff;
            font-size: 12px;
            cursor: pointer;
        }*/

.cell-close {
    background-color: #9aa3af;
}

.cell-close:after {
    content: "锁定";
    position: absolute;
    bottom: 8px;
    right: 8px;
    color: #fff;
    font-size: 12px;
    cursor: pointer;
}

.fc-header tr {
    background-color: #f8fafb;
}

.fc-content {
    font-size: 14px;
}

.fc-cell {
    color: #364860;
}

.fc-cell-past {
    background-color: #ecedef;
}

.fc-cell-last-month,
.fc-cell-next-month {
    opacity: 1;
}

.fc-cell-last-month .fc-date,
.fc-cell-next-month .fc-date {
    color: #c0c3c9;
}

</style>
<div class="content-header">
    <ol class="breadcrumb">
        <li><a href="#">产品中心</a></li>
        <li class="active">库存列表</li>
    </ol>
    <h2><span>库存列表</span></h2>
</div>
<div class="content-body j_stock">
    <div class="form-top-wrapper">
        <form action="<%=path %>/stock/queryStock" name="stock-list-form_g" method="post" class="form-inline" fresh-self>
            <div class="row">
                <label class="col-xs-4">
                    库存类别
                    <select class="form-select" name="category">
                       	<option value="" <c:if test="${ruleQuery.category == ''}">selected='selected'</c:if>>全部</option>
                        <c:forEach items="${ categorys }" var="categorys" varStatus="categorysindex">
							<option value="${categorys.categoryCode }" <c:if test="${ruleQuery.category == categorys.categoryCode}">selected='selected'</c:if>>${categorys.categoryName }</option>
						</c:forEach>
                    </select>
                </label>
                <label class="col-xs-4">
                    库存名称
                    <input type="text" value="${ruleQuery.vagueName }" name="vagueName" class="form-control">
                </label>
                <%-- <label class="col-xs-4">
                    关联产品集
                    <input type="text" class="form-control" value="${productNames }" name="productNames">
                </label> --%>
                
            </div>
            <input type="hidden" name="currentPage" value="${stocks.currentPage }"/>
            <div class="row">
                <div class="row-btn-group">
                    <button type="button" class="btn btn-primary btn-fixed-lg" onclick="stockList_list_g();" style="margin-left: 20px;">搜索</button>
                </div>
            </div>
        </form>
        <div class="table-top-btns">
            <button class="btn btn-primary btn-fixed-lg j_add" onclick="javascript:jumpUrl('/stock/toAddStock');">新增库存</button>
        </div>
        <div class="j_theatre j_doc_pagination">
        <table class="table table-bordered">
                <thead>
                    <tr>
                        <th>序号</th>
                        <th>库存名称</th>
                        <th>库存类别</th>
                        <th>库存类型</th>
                        <th>操作</th>
                    </tr>
                </thead>
                    <c:if test="${not empty stock }">
                    	<c:forEach items="${ stock }"  var="l" varStatus="autoindex" >
                		<tbody>
                    		<td>${autoindex.index +1 }</td>
                    		<td><a href="#" onclick="javascript:jumpUrl('/stock/toViewStock?sid=${l.id }');">${l.name}</a></td>
                    		<td>
                    			<c:forEach items="${ categorys }" var="categorys">
                    				<c:if test="${l.category == categorys.categoryCode}">
                    					${categorys.categoryName }
                    				</c:if>
								</c:forEach>
                    		</td>
                    		<td>
                    		<c:forEach items="${ types }" var="types">
                    			<c:if test="${l.type == types.ruleType}">
                    				${types.ruleName }
                    			</c:if>
                    		</c:forEach>
                    					
                    		</td>
                    		<td>
                    			<c:forEach items="${ validSku }" var="validSku">
                    				 <c:if test="${ validSku.stockRuleId== l.id}">
                    				 	<c:if test="${ validSku.isHaveRelation}">
	                    					<button type="button" class="btn btn-primary btn-sm j_relation" strId="${l.id}" strName="${l.name }">关联集合</button>
	                    					<c:if test="${ l.type==2 }"> 
	                            			<button tupe="button" class="btn btn-primary btn-sm j_lock" strId="${l.id}" strName="${l.name }" data-status='1'>锁定</button>
	                            			<button type="button" class="btn btn-primary btn-sm j_unlock" strId="${l.id}" strName="${l.name }" data-status='1'>解锁</button>
	                            			 </c:if>
	                    					<c:if test="${ l.type==1 }"> 
	                            			<button tupe="button" class="btn btn-primary btn-sm j_lock" strId="${l.id}" strName="${l.name }" data-status='2'>锁定</button>
	                            			<button type="button" class="btn btn-primary btn-sm j_unlock" strId="${l.id}" strName="${l.name }" data-status='2'>解锁</button>
	                            			</c:if>
                            			</c:if>
                    				 	<c:if test="${! validSku.isHaveRelation}">
	                    					<button type="button" class="btn btn-primary btn-sm" onclick="deleteStock(${l.id });">删除</button>
	                            			<button type="button" class="btn btn-primary btn-sm j_modify" onclick="javascript:jumpUrl('/stock/toUpdateStock?sid=${l.id }');">修改</button>
                    				 	</c:if>
                    				 </c:if>
                            	</c:forEach> 
							</td>
		                </tbody>
                    	</c:forEach>
                    </c:if>
        </table>
        <div class="pagination-wrapper stock_list_page"></div>
        </div>
    </div>
</div>
<!-- 关联产品集 -->
<div class="modal fade" id="relation_modal">
    <div class="modal-dialog" role="document" style="width: 600px;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">关联集合</h4>
            </div>
            <div class="modal-body">
                <form class="panel panel-square">
                        <div class="panel-heading panel-heading-sm">
                          	库存名称:<span class="productName"></span>
                        </div>
                        <div class="panel-body">
                            <p class="form-group">关联产品集:</p>
                       		 <ul class="productList" style="margin: 0">
                       		 </ul>
                      </div>
                </form>
            </div>
            <div class="modal-footer row-btn-group">
                <button type="button" class="btn btn-primary btn-fixed-lg" data-dismiss="modal">确定</button>
            </div>
        </div>
    </div>
</div>
<!-- 锁定 -->
<div class="modal fade" id="lock_modal" style="overflow: auto;" >
    <div class="modal-dialog" role="document" style="width: 940px;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">锁定</h4>
            </div>
            <div class="modal-body">
                <form action="<%=path %>/stock/locks" class="form1 form-inline stockNewlocks" data-status="1" fresh-self>
                	<input type="hidden" name="operateType" value="4">
                	<input type="hidden" name="id" class="stockids">
                    <p class="form-group">库存名称:<span id='lockFrom1'></span></p>
                    <div class="form-group">
                        <!-- <div style="display: inline-block">
                            <div class="form-control-calendar">
                                <input type="text" class="form-control j_only_md">
                                <i class="fa fa-calendar"></i>
                            </div>
                        </div> -->
                        <button class="btn btn-primary mg-l-sm select-time" type="button">选择时间</button>
                        <button type="button" class="btn btn-primary btn-sm  j_item">逐条锁定</button>
                        <button type="button" class="btn btn-primary btn-sm  j_batch">批量锁定</button>
                        <div class="isvisible isDisabled">
                            <label class="label-checkbox" style="margin-left: 30px;">
                                <input type="radio" name="bathLock" value="1"> 锁定所有可用
                            </label>
                            <label class="label-checkbox">
                                <input type="radio" name="bathLock" value="2"> 锁定部分可用
                            </label>
                            <input type="text" name="bathNums" onkeyup="this.value=this.value.replace(/[^\d]/g,'') " class="form-control _this_text_input" style="margin-left: 20px;width: 150px;">
                        </div>
                    </div>
                    <div class="form-inline">
                        <ul class="list-horizontal" style="margin: 0">
                        </ul>
                    </div>
                    <div class="row-btn-group">
                        <button type="button" class="btn btn-primary btn-fixed-lg" onclick="onLockClick(1);">锁定</button>
                        <button type="button" class="btn btn-primary btn-fixed-lg" data-dismiss="modal">返回</button>
                    </div>
                </form>
                <form action="<%=path %>/stock/lock" class="form2 form-inline stockNewLockc" data-status="2" fresh-self>
                	<input type="hidden" name="operateType" value="4">
                	<input type="hidden" name="id" class="stockids">
                    <p class="form-group">库存名称:<span id='lockFrom2'></span></p>
                    <p class="form-group">库存上限:<span class='lockFrom2'></span></p>
                    <div class="form-inline">
                        <ul class="list-horizontal" style="margin: 0">
                            <li class="form-group" style="margin-bottom: 20px;">
                                	现有库存:<span class="mg-l-sm" id="lockNewNums"></span>
                                	已锁库存:<span class="mg-l-sm" id="lockNewlocks"></span>
                                <div class="lock-isvisible isDisabled">
                                    <label class="label-checkbox mg-l-sm">
                                        <input type="radio" name="lock" value="1"> 锁定所有可用
                                    </label>
                                    <label class="label-checkbox mg-l-sm">
                                        <input type="radio" name="lock" value="2" checked> 锁定部分可用
                                    </label>
                                    <input type="text" name="lockNum" onkeyup="this.value=this.value.replace(/[^\d]/g,'') " class="form-control _this_text_input" style="margin-left: 20px;">
                                </div>
                                <!-- <button type="button" class="btn btn-primary btn-sm delete" style="margin-left:20px">删除</button> -->
                            </li>
                        </ul>
                    </div>
                    <div class="row-btn-group">
                        <button type="button" class="btn btn-primary btn-fixed-lg" onclick="unLockClick(1);">锁定</button>
                        <button type="button" class="btn btn-primary btn-fixed-lg" data-dismiss="modal">返回</button>
                    </div>
                </form>
            </div>
            
        </div>
    </div>
</div>
<!-- 解锁 -->
<div class="modal fade" id="unlock_modal" style="overflow: auto;">
    <div class="modal-dialog" role="document" style="width: 944px;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">解锁</h4>
            </div>
            <div class="modal-body">
                <form action="" class="form1 form-inline stockNewlockss" data-status="1" fresh-self>
                	<input type="hidden" name="operateType" value="5">
                	<input type="hidden" name="id" class="unStockids">
                    <p class="form-group">库存名称:<span id="unLockForm1"></span></p>
                    <span class="stockLimitc"><p class="form-group">库存上限:<span class="stockNumClass"></span></p></span>
                    <span style="display:none" class="stockLimita"><p class="form-group">&nbsp;&nbsp;&nbsp;&nbsp;没有锁定库存</p></span>
                    <div class="form-inline">
                        <ul class="list-horizontal unLockStockUl" style="margin: 0">
                            
                        </ul>
                    </div>
                    <div class="row-btn-group">
                        <button type="button" class="btn btn-primary btn-fixed-lg" onclick="onLockClick(2);">解锁</button>
                        <button type="button" class="btn btn-primary btn-fixed-lg" data-dismiss="modal">返回</button>
                    </div>
                </form>
                <form action="<%=path %>/stock/lock" class="form2 form-inline stockNewLockd" data-status="2" fresh-self>
                	<input type="hidden" name="operateType" value="5">
                	<input type="hidden" name="id" class="unStockids">
                    <p class="form-group">库存名称:<span id="unLockForm2"></span></p>
                    <p class="form-group stockLimitc">库存上限:<span class="unlockFrom2"></span></p>
                    <p class="form-group stockLimit" type="hidden">&nbsp;&nbsp;&nbsp;&nbsp;没有锁定库存</p>
                    <div class="form-inline">
                        <ul class="list-horizontal" style="margin: 0">
                            <li class="form-group" style="margin-bottom: 20px;">
                                	现有存库:<span class="mg-l-sm" id="lockNewNum"></span>
                                	已锁库存:<span class="mg-l-sm" id="lockNewlock"></span>
                                <div class="lock-isvisible isDisabled">
                                    <label class="label-checkbox mg-l-sm">
                                        <input type="radio" name="lock2" value="1"> 解锁所有可用
                                    </label>
                                    <label class="label-checkbox mg-l-sm" >
                                        <input type="radio" name="lock2" value="2" checked> 解锁部分可用
                                    </label>
                                    <input type="text" name="lockNum" onkeyup="this.value=this.value.replace(/[^\d]/g,'') " class="form-control _this_text_input" style="margin-left: 20px;">
                                </div>
                                <!-- <button type="button" class="btn btn-primary btn-sm delete" style="margin-left:20px">删除</button> -->
                            </li>
                        </ul>
                    </div>
                    <div class="row-btn-group">
                        <button type="button" class="btn btn-primary btn-fixed-lg" onclick="unLockClick(2);">解锁</button>
                        <button type="button" class="btn btn-primary btn-fixed-lg" data-dismiss="modal">返回</button>
                    </div>
                </form>
            </div>
            
        </div>
    </div>
</div>
<!-- 显示日期的控件 -->
<div class="modal fade j_settime-modal">
    <div class="modal-dialog" style="width: 650px;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">选择日期</h4>
            </div>
            <div class="modal-body">
                <div class="calendar"></div>
            </div>
            <div class="modal-footer">
            	<!-- <button type="button" class="btn btn-primary btn-fixed-lg">清空</button> -->
                <button type="button" class="btn btn-primary btn-fixed-lg settime_sure stocklickClick">确定</button>
                <button type="button" class="btn btn-primary btn-fixed-lg" data-dismiss="modal">关闭</button>
            </div>
        </div>
    </div>
</div>
<script type="text/javascript">
	var jumpUrl = function(url){
		if(typeof url == "undefined"){
			return;
		}else{
		$.MFT.pages.refreshTab('<%=path %>'+url);
		}
	}
	function deleteStock(sid){
		$.ajax({
			type:"POST",
			url:"<%=path%>/stock/deleteStock", 
			async:false,
			data:{sid:sid},
			success:function(data){
				if(data.code==10000){
					alert(data.message);
					jumpUrl("/stock/list");
				}
			},
			error:function(json){
				alert("网络忙，稍后再试");
			}		
		}); 
	
	}
	function unLockClick(num){
		var json = "";
		if(num==1){
			var lock = $("input[name='lock']:checked").val();
			if(lock==1){
				json = $(".stockNewLockc").serialize()+"&lockNum="+$("#lockNewNums").text();
			}else{
				json = $(".stockNewLockc").serialize();
			}
		}
		if(num==2){
			var lock = $("input[name='lock2']:checked").val();
			if(lock==1){
				json = $(".stockNewLockd").serialize()+"&lockNum="+$("#lockNewlock").text();
			}else{
				json = $(".stockNewLockd").serialize();
			}
		}
		$.ajax({
			type:"POST",
			url:"<%=path%>/stock/lock",
			async:false,
			data:json,
			dataType:"json",
			success:function(data){
				if(data.success){
					jumpUrl("/stock/list");
				}else{
					alert(data.errorMsg);
				}
			},
			error:function(json){
				alert("网络忙，稍后再试");
			}		
		}); 
	
	}
	function onLockClick(type){
		if(type==1){
			var json = $(".stockNewlocks").serialize();
		}
		if(type==2){
			var json = $(".stockNewlockss").serialize();
		}
		$.ajax({
			type:"POST",
			url:"<%=path%>/stock/locks",
			async:false,
			data:json,
			dataType:"json",
			success:function(json){
				if(json.success){
					jumpUrl("/stock/list");
				}else{
					alert(json.errorMsg);
				}
			},
			error:function(json){
				alert("网络忙，稍后再试");
			}		
		}); 
	
	}
	
	
    $(function() {
    	
        var wrap = $('.j_stock');
        var $relation_modal = $('#relation_modal');
        var $lock_modal = $('#lock_modal');
        var $unlock_modal = $('#unlock_modal');
        var $form1 = $lock_modal.find('.form1'); 

        $(".settime_sure").on('click',function(){
        	$('.j_settime-modal').modal('hide');
        })

        <%-- //新增库存
        wrap.find('.j_add').on('click',  function(e) {
            e.preventDefault();
            // 刷新当前tab页面
            $.MFT.pages.refreshTab('<%=path%>/modules/enterprise/stock/add-stock.jsp')
        }) --%>

        //修改库存----跳转页面
        wrap.find('.j_modify').on('click',  function(e) {
            e.preventDefault();
            // 刷新当前tab页面
            $.MFT.pages.refreshTab('<%=path%>/modules/enterprise/stock/modify-stock.jsp')
        })

        //关联集合弹窗   点击清空数据
        wrap.find('.j_relation').on('click',  function(e) {
        	$("span.productName").html($(this).attr("strName"));
        	var id = $(this).attr("strId");
        	$.ajax({
     			type:"POST",
     			url:"<%=path %>/stock/selectProduct", 
     			data:{stockId:id},
     			async: false,
     			dataType:"json",
     			success:function(json){
     				if(json.sucess){
     					var str = "";
     					var product = json.products;
    					for(var i=0;i<product.length;i++){
    						str+="<label class='check-fixed'>"+product[i].name+"</label>";
    					}
    					$(".productList").html(str);
     				}else{
     					alert(json.errorMsg);
     				}
     			},
     			error:function(json){
     				alert("网络忙，稍后再试");
     			}
     		});
        	
            $relation_modal.find('form').trigger('reset');
            $relation_modal.find('input[type="checkbox"]').iCheck();
            $relation_modal.modal();
        });


        // 点击锁定根据数据展示不同的模块    
        var strid="";
        wrap.find('.j_lock').on('click',  function(e) {
            $lock_modal.find('input').prop('disabled', false);
            $form1.find('.lock-isvisible').css("visibility","hidden");
            var status = $(this).data('status');
            strid = $(this).attr("strId");
       	 	var strname = $(this).attr("strName");
            if(status == '1'){
                 $form1.find('.isvisible').css("visibility","hidden");
                 $form1.find('.j_item').hide();  
                 $form1.find('.j_batch').hide();  
                 $form1.find('.list-horizontal').hide();  
                 $("#lockFrom1").html(strname);
                 $lock_modal.find('form[data-status="1"]').show();   
                 $lock_modal.find('form[data-status="2"]').hide();  
            }else {
            	 $.ajax({
         			type:"POST",
         			url:"<%=path %>/stock/selectLock", 
         			data:{id:strid},
         			async: false,
         			dataType:"json",
         			success:function(json){
         				if(json.sucess){
         					//剩余库存数 
         					//现有库存
         					$("#lockNewNums").html((json.stockModels[0]).remainNum);
         					//已锁库存
         					$("#lockNewlocks").html((json.stockModels[0]).usedNum);
         					$(".stockids").val((json.stockModels[0]).id);
         					$(".lockFrom2").html((json.stockModels[0]).totalNum);
         				}else{
         					alert(json.errorMsg);
         				}
         			},
         			error:function(json){
         				alert("网络忙，稍后再试");
         			}
         		});
            	 $("#lockFrom2").html(strname);
                 $lock_modal.find('form[data-status="1"]').hide();  
                 $lock_modal.find('form[data-status="2"]').show();     
            }
               

            $lock_modal.find('form').trigger('reset');
            $lock_modal.find('input[type="text"]').prop('disabeld',false);
            $lock_modal.find('input[type="radio"]').iCheck();
            $lock_modal.modal();
        });



        



        // 锁定弹窗----批量锁定---单独模块    
        $form1.find('.j_item').on('click', function(){
            $lock_modal.find('.lock-isvisible').css("visibility","visible");
             $lock_modal.find('.isvisible').css("visibility","hidden");
        });

        $form1.find('.j_batch').on('click', function(){
            $form1.find('.lock-isvisible').css("visibility","hidden");
            $form1.find('.isvisible').css("visibility","visible");
        }); 
        // 锁定弹窗----批量锁定---单独模块     
        
        // 锁定根据数据----点击时input---disabled    
        $lock_modal.find('.isDisabled').on('ifClicked','input[type="radio"]',function(){
            var value = $(this).val();
            if(value == 1){
                $(this).closest('.isDisabled').find('._this_text_input').prop('disabled', true);
                $(this).closest('.isDisabled').find('._this_text_input').val("");
            }else {
                $(this).closest('.isDisabled').find('._this_text_input').prop('disabled', false);
            }
        })   

        // 库存名称点击跳转不同地址    
        wrap.find('.j_href').on('click', function(e){
            e.preventDefault();
            var status = $(this).data('status');
            if(status == '1'){
                $.MFT.pages.refreshTab('<%=path%>/modules/enterprise/stock/modify-stock.jsp');
            }else {
                $.MFT.pages.refreshTab('<%=path%>/modules/enterprise/stock/stock-info.jsp');
            }
        })

        //日历插件调用    
        $('.j_only_md').datepicker({
            maxViewMode: 1,
            format: 'yyyy-mm-dd'
        })
        .on('show', function(event) {
            event.preventDefault()
            var datepicker = $(this).data('datepicker')
            var switcher = datepicker.picker.find('.datepicker-switch').eq(0)
            var year = datepicker.viewDate.getFullYear()
            var text = switcher.text()

            switcher.text( text.replace(year, '') )
        });

        //锁定---日历插件值变化时的操作
         
        $('.stocklickClick').on('click',function(){
        	var a = $(".calendar").find(".cell-close");
        	stockTimes = "";
        	for(var i=0;i<a.length;i++){
        		var $this=$(a[i]).parent().attr('date');
        		stockTimes += $this+",";
        	}
        	$.ajax({
     			type:"POST",
     			url:"<%=path %>/stock/selectLockbyTime", 
     			data:{id:strid,stockTime:stockTimes},
     			async: false,
     			dataType:"json",
     			success:function(json){
     				if(json.sucess){
     					var str = "";
     		        	//显示锁定时间
     		        	var stockModel = json.stockModels;
     		        	for(var i=0;i<stockModel.length;i++){
     		        		var $this=$(a[i]).parent().attr('date');
     		        		//获取选择日期
     		        		str+="<li class='form-group' style='margin-bottom: 20px;'><span class='mg-l-sm'>"+stockModel[i].stockTime+"</span>";
     		        		str+="<input type='hidden' name='stockId' value="+stockModel[i].id+"#"+stockModel[i].ruleId+"#"+stockModel[i].stockTime+">";
     		        		str+="<input type='hidden' name='bathLockNum' value="+stockModel[i].remainNum+">";
     		        		str+="<span class='mg-l-sm'>现有存库:"+stockModel[i].remainNum+"</span><span class='mg-l-sm'>已锁库存:"+stockModel[i].usedNum+"</span>";
     		        		str+="<div class='lock-isvisible isDisabled'><label class='label-checkbox mg-l-sm'>";
     		        		/* str+="<input type='radio' name='lock"+[i]+"' value='1'> 锁定所有可用</label>"; */
     		        		str+="<label class='label-checkbox mg-l-sm'> 锁定库存数量</label>";
     		        		str+="<input type='text' name='lockNumsd' class='form-control _this_text_input' style='margin-left: 20px;'></div>";
     		        		str+="<button type='button' class='btn btn-primary btn-sm delete' style='margin-left:20px'>删除</button></li>";
     		            	
     		        	}
     		        	$form1.find('.list-horizontal').html(str);
     				}else{
     					alert(json.errorMsg);
     				}
     			},
     			error:function(json){
     				alert("网络忙，稍后再试");
     			}
     		});
        	$lock_modal.find('.j_item').show();
        	$lock_modal.find('.j_batch').show();
        	
        	$form1.find('.list-horizontal').iCheck();
        	$form1.find('.list-horizontal').show();
        	$form1.find('.lock-isvisible').css("visibility","visible");
        	$lock_modal.find('.isDisabled').on('ifClicked','input[type="radio"]',function(){
                var value = $(this).val();
                if(value == 1){
                    $(this).closest('.isDisabled').find('._this_text_input').prop('disabled', true);
                    $(this).closest('.isDisabled').find('._this_text_input').val("");
                }else {
                    $(this).closest('.isDisabled').find('._this_text_input').prop('disabled', false);
                }
            })  
        })



        //锁定删除
        $lock_modal.on('click','.delete',function(){
            var $this = $(this);
            $this.closest('li').remove();
            var length = $lock_modal.find('.list-horizontal li').length;
            if(!length){
                 $form1.find('.j_item').hide();  
                 $form1.find('.j_batch').hide();   
            }
        })


        //解锁   
		
        wrap.find('.j_unlock').on('click',  function(e) {
            $unlock_modal.find('input').prop('disabled', false);
            var status = $(this).data('status');
            var strid = $(this).attr("strId");
      	 	var strname = $(this).attr("strName");
      	 	var strs = "";
            if(status == '1'){
            	$.ajax({
         			type:"POST",
         			url:"<%=path %>/stock/selectLocks", 
         			data:{id:strid},
         			dataType:"json",
         			success:function(json){
         				if(json.sucess){
         					if(json.stockModelList==undefined){
         						$(".stockLimitc").hide();
         						$(".stockLimita").show();
         					}else{
         						$(".stockLimitc").show();
         						$(".stockLimita").hide();
         						var list = json.stockModelList;
             					for(var i=0;i<list.length;i++){
             						strs+="<li class='form-group' style='margin-bottom: 20px;'><span class='mg-l-sm'>"+list[i].stockTime+"</span>";
             		        		strs+="<input type='hidden' name='clseLockTime' value="+list[i].stockTime+">";
             		        		strs+="<input type='hidden' name='stockId' value="+list[i].id+">";
             		        		strs+="<span class='mg-l-sm'>现有存库:"+list[i].remainNum+"</span><span class='mg-l-sm'>已锁库存:"+list[i].usedNum+"</span>";
             		        		strs+="<div class='lock-isvisible isDisabled'><label class='label-checkbox mg-l-sm'>";
             		        		/* strs+="<input type='radio' name='lock"+[i]+"' value='1'> 解锁所有可用</label>"; */
             		        		strs+="<label class='label-checkbox mg-l-sm'><input type='radio' name='lock"+[i]+"' value='2' checked> 解锁部分可用</label>";
             		        		strs+="<input type='text' name='lockNumsd' class='form-control _this_text_input' style='margin-left: 20px;'></div>";
             		        		strs+="<button type='button' class='btn btn-primary btn-sm delete' style='margin-left:20px'>删除</button></li>";
             					}
             		        	$(".unLockStockUl").html(strs);
             		        	$(".unStockids").val((json.stockModelList)[0].id);
             		        	$(".stockNumClass").html((json.stockModelList)[0].totalNum);
             		        	$unlock_modal.find('.list-horizontal').iCheck();
             		        	$unlock_modal.find('.isDisabled').on('ifClicked','input[type="radio"]',function(){
             		               var value = $(this).val();
             		               if(value == 1){
             		                   $(this).closest('.isDisabled').find('._this_text_input').prop('disabled', true);
             		                  $(this).closest('.isDisabled').find('._this_text_input').val("");
             		               }else {
             		                   $(this).closest('.isDisabled').find('._this_text_input').prop('disabled', false);
             		               }
             		           })
         					}
         				}else{
         					alert(json.errorMsg);
         				}
         			},
         			error:function(json){
         				alert("网络忙，稍后再试");
         			}
         		 });
            	 $("#unLockForm1").html(strname);
                 $unlock_modal.find('form[data-status="1"]').show(); 
                 $unlock_modal.find('form[data-status="2"]').hide();  
            }else {
           	 	$.ajax({
         			type:"POST",
         			url:"<%=path %>/stock/selectLock", 
         			data:{id:strid},
         			dataType:"json",
         			success:function(json){
         				if(json.sucess){
         					if(json.stockModels==undefined){
         						$(".stockLimitc").hide();
         						$(".stockLimit").show();
         					}else{
         						//剩余库存数 
             					//现有库存
             					$("#lockNewNum").html((json.stockModels[0]).remainNum);
             					//已锁库存
             					$("#lockNewlock").html((json.stockModels[0]).usedNum);
             					$(".unStockids").val((json.stockModels[0]).id);
             					$(".unlockFrom2").html((json.stockModels[0]).totalNum);
         					}
         					
         				}else{
         					alert(json.errorMsg);
         				}
         			},
         			error:function(json){
         				alert("网络忙，稍后再试");
         			}
         		 });
           	     $("#unLockForm2").html(strname);
                 $unlock_modal.find('form[data-status="1"]').hide();  
                 $unlock_modal.find('form[data-status="2"]').show();     
            }
            $unlock_modal.find('form').trigger('reset');
            $unlock_modal.find('input[type="text"]').prop('disabeld',false);
            $unlock_modal.find('input[type="radio"]').iCheck();
            $unlock_modal.modal();
        });    


        $unlock_modal.find('.isDisabled').on('ifClicked','input[type="radio"]',function(){
            var value = $(this).val();
            if(value == 1){
                $(this).closest('.isDisabled').find('._this_text_input').prop('disabled', true);
                $(this).closest('.isDisabled').find('._this_text_input').val("");
            }else {
                $(this).closest('.isDisabled').find('._this_text_input').prop('disabled', false);
            }
        })


        $unlock_modal.on('click','.delete',function(){
            var $this = $(this);
            $this.closest('li').remove();
        })
        $('.select-time').on('click',function() {
            $('.calendar').calendar({
                // defaultDate: '2016-06',
                // titleFormat: 'YYYY/MM',
                // hasToolbar: false,
                // dayNamesShort: ['周日','周一','周二','周三','周四','周五','周六'],
                // height: '20px',
                hasToolbar: true,
                fixedDays: true,
                onDayClick: function(td, data, e) {
                    if (td.hasClass('fc-cell-past')) return;
                    var cell = td.children('.fc-content');
                    cell.toggleClass('cell-close');
                },
                onViewRender: function(view) {
                    var date = this._date.format('YYYY-MM-DD')
                    var today = moment().format('YYYY-MM-DD')
                    var method = date > today ? 'removeClass' : 'addClass';
                    $('#calendar').find('.fc-prev-button')[method]('disabled')
                },
                // onDayRender: function(date, cell) {},
                onDataRender: function(data, cell) {
                    if (cell.parent().hasClass('fc-cell-past')) return;
                    cell.addClass('cell-close');
                },
                data: []
            });
            $('.j_settime-modal').modal();
        });
    });
    $(function() { 
	    var wrap2 = $('.j_doc_pagination');
	    wrap2.find('.stock_list_page').pagination({
	    	pages:${stocks.totalPage},
	    	currentPage:${stocks.currentPage},
	        onPageClick: function(pageNumber) {
	            $("input[name='currentPage']").val(pageNumber);  
	            $("form[name='stock-list-form_g']").submit();
	        }
	    });
	})
    function stockList_list_g(){
        $("input[name='currentPage']").val(1);  
        $("form[name='stock-list-form_g']").submit();
	}
    
</script>
