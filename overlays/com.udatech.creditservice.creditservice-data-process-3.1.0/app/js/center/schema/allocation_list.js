var al = (function () {

    // 组织冒泡事件，防止点击事件和拖动事件冲突
	window.setTimeout(function(){
		try{
			stopBubble();
		}catch(e){

		}
    },1500);

	//页面初始化禁用保存按钮
    $("#saveBtn").attr("disabled", "disabled");
    //左侧树形上方按钮默认无法使用
    $("#copySchemaBtn,#editSchemaBtn,#delSchemaBtn").hide();
    //页面初始化重复数据下拉置空
    $("#cfsj").cclSelect({
        data : '',
    });
    //重复数据下拉不可点击
    $("#cfDiv").addClass("hideDiv");

    var oldDepts;
    var tableId = null;	    //	表ID
    var tableCode = null;   // table code
    var sortNum = 0;	    //	排序序号
    var sortList = [];	    //	排序列表
    var checkedList=[]; //勾选的列表
    var dp_table_version_config_id=null;//存放节点对应的dp_table_version_config 的id，用来保存时存储DP_COLUMN_VERSION_CONFIG 中的
    var tableVersionId=null;//存放版本编号
    var schemaNodes = [];
    var currentNode;
    var selectNode;//记录选中的节点，用来节点切换选中时，未成功切换则恢复至原来的节点选中
    var flagXg=true;//进入页面首次点击目录并不校验右侧是否有修改，成功点击之后
    var msg;//记录目录节点切换时右侧修改部分的提示信息
    var oldTableData=[];//存放点击页面时右侧 table 加载的数据 todo
    var newTableData=[];//存放右侧页面修改后 table 的数据
    var oldDeptAndBdData=[];//存放点击页面时右侧 机构和比对 加载的数据
    var sfpx=false;//默认不排序-右侧全勾选或取消不影响排序，只有单独勾选时才自动排序

    //	美化radio
    $("#compareTime,#compareSameDate,#showAll").iCheck({
        labelHover : true,
        checkboxClass : 'icheckbox_square-blue',
        radioClass : 'iradio_square-blue',
        increaseArea : '20%'
    });

    //初始化右侧下拉选项内容
    function initSjdb(){
        $.ajaxSettings.async = false;
        $.getJSON(ctx + "/schema/getCfsjList.action", {
            tableId : tableId,
            dp_table_version_config_id : dp_table_version_config_id,
            date : '1'//加载是date类型的指标
        },function(result) {
            $("#start option").remove();
            // 初始下拉框
            $("#start").select2({
                placeholder : '请选择',
                allowClear : false,
                language : 'zh-CN',
                data : result
            });
            $('#start').val([]).trigger('change');
            resizeSelect2($("#start"));
            $("#end option").remove();
            $("#end").select2({
                placeholder : '请选择',
                allowClear : false,
                language : 'zh-CN',
                data : result,
            });
            $('#end').val([]).trigger('change');
            resizeSelect2($("#end"));
        });
        $.getJSON(ctx + "/schema/getCfsjList.action", {
            tableId : tableId,
            dp_table_version_config_id : dp_table_version_config_id,
            date : '0'//加载所有保存的指标
        },function(result) {
            //清除cclSelect
            $("#cfsj").cclSelectRemove();
            $("#cfsj").cclSelect({
                data : result,

            });
        });
        $.ajaxSettings.async = true;
    }

    //监控显示上报配置
    $("#showAll").on('ifChecked ifUnchecked', function(event){
        if(event.type=='ifChecked'){
            //显示启用的上报配置
            initSchemaTree('1');
        }else{
            //显示所有的上报配置
            initSchemaTree('0');
        }
        //schemaTree初始化后无选中节点，隐藏
        $("#copySchemaBtn,#editSchemaBtn,#delSchemaBtn").hide();
    });

    //监控比对条件-控制下方选项是不是可以选
    $("#compareTime").on('ifChecked ifUnchecked', function(event){
        if(event.type=='ifChecked'){
            $("#start").attr("disabled",false);
            $("#end").attr("disabled",false);
        }else{
            $("#start").attr("disabled",true);
            $("#end").attr("disabled",true);
        }
    });
    $("#compareSameDate").on('ifChecked ifUnchecked', function(event){
        if(event.type=='ifChecked'){
            //显示启用的上报配置
            $("#cfDiv").removeClass("hideDiv");
        }else{
            //显示所有的上报配置
            $("#cfDiv").addClass("hideDiv");
        }
    });
    $("#start").select2({
        placeholder : '请选择',
        allowClear : false,
        language : 'zh-CN',
        data : ''
    });
    $('#start').val([]).trigger('change');
    resizeSelect2($("#start"));
    $("#end option").remove();
    $("#end").select2({
        placeholder : '请选择',
        allowClear : false,
        language : 'zh-CN',
        data : '',
    });
    $('#end').val([]).trigger('change');
    resizeSelect2($("#end"));

    function initRightForSchema(treeNode){
        oldDeptAndBdData=[];
        $("#start option").remove();
        $("#end option").remove();
        $("#cfsj").cclSelectRemove();
        $("#cfsj").cclSelect({
            data : '',

        });
        //  初始化目录名称、编码、授权部门等信息
        $("#department").val("");
        $("#departments").val("");
        $(".ccl-multi-select-li").remove();
        $(".ccl-multi-select-active").removeClass("ccl-multi-select-active");

        // 获取授权部门
        $.post(ctx + "/schema/getBbDeptList.action", {
            table_version_config_id : treeNode.TABLE_VERSION_CONFIG_ID
        }, function (json) {
            if (json && json.length > 0) {
                var depts = "";
                for (var i=0; i<json.length; i++) {
                    var dept = json[i];
                    if (dept && dept.id) {
                        depts += dept.id;
                        if (i < json.length - 1) {
                            depts += ",";
                        }
                        $("#department option[value='" + dept.id + "']").attr("selected", "selected");
                    }
                }
                $("#departments").val(depts);
                oldDepts = depts;
                $("#department").change();
                var co={};
                co["department"]=depts;
                oldDeptAndBdData.push(co);
            }else{
                //如果机构为空，则放置空数据（为了保证oldDeptAndBdData存在两个元素，方便节点切换时进行对比）
                var co={};
                co["department"]='';
                oldDeptAndBdData.push(co);
            }
        }, "json");
        //  启用右侧操作按钮
        $("#saveBtn").removeAttr("disabled");
        //  获取指标列表
        tableId = treeNode.ID;
        tableCode = treeNode.CODE;
        // version=treeNode.VERSION;
        tableVersionId=treeNode.TABLE_VERSION_ID;
        dp_table_version_config_id=treeNode.VERSION_ID;

        sortNum = 0;	    //	排序序号
        sortList = [];	    //	排序列表
        initFieldList();//加载右侧table列表数据
        initSjdb();//加载右侧下拉框内容
        //获取比对数据
        $.post(ctx + "/schema/getBbMlBdSj.action", {
            "versionId" : treeNode.TABLE_VERSION_CONFIG_ID
        }, function (json) {
            if(json!=null){
                if(json.isCheckDate=='0'){
                    $("#compareTime").iCheck('uncheck');
                    $("#start").attr("disabled",true);
                    $("#end").attr("disabled",true);
                }else{
                    $("#compareTime").iCheck('check');
                    $("#start").attr("disabled",false);
                    $("#end").attr("disabled",false);
                }
                if(json.isCheckRepeat=='0'){
                    $("#compareSameDate").iCheck('uncheck');
                    $("#cfDiv").addClass("hideDiv");
                }else{
                    $("#compareSameDate").iCheck('check');
                    $("#cfDiv").removeClass("hideDiv");
                }
                $("#start").val(json.beginDateCode).trigger("change");
                $("#end").val(json.endDateCode).trigger("change");
                var repeatCodeArr=[];
                if(json.repeatCodes!=null){
                    repeatCodeArr=json.repeatCodes.split(',');
                    for(var i=0;i<repeatCodeArr.length;i++){
                        $("#cfsj option[value='" + repeatCodeArr[i]+ "']").attr("selected", "selected");
                    }
                    $("#cfsj").change();
                }

                var co={};
                co["isCheckDate"]=json.isCheckDate;
                co["isCheckRepeat"]=json.isCheckRepeat;
                co["beginDateCode"]=json.beginDateCode;
                co["endDateCode"]=json.endDateCode;
                co["repeatCodes"]=json.repeatCodes;
                oldDeptAndBdData.push(co);
            }

        }, "json");
    }

    function addDiyDom(treeId, treeNode) {
        var switchObj = $("#" + treeNode.tId + "_switch"),
        icoObj = $("#" + treeNode.tId + "_ico");
        switchObj.remove();
        icoObj.parent().before(switchObj);
        var spantxt = $("#" + treeNode.tId + "_span").html();
        if (spantxt.length > 6) {
            spantxt = spantxt.substring(0, 6) + "...";
        }
        if(treeNode.level=='0'){
            if(treeNode.STATUS=='1'){
                $("#" + treeNode.tId + "_span").html(spantxt+'<input id=\"' + treeNode.ID + '\" type=\"checkbox\" checked class=\"make-switch\" name=\"changeStatus\" data-size=\"mini\" />');
            }else{
                $("#" + treeNode.tId + "_span").html(spantxt+'<input id=\"' + treeNode.ID + '\" type=\"checkbox\"  class=\"make-switch\" name=\"changeStatus\" data-size=\"mini\" />');
            }

            $("input[name='changeStatus']").bootstrapSwitch({
                onText : "开启",      // 设置ON文本  
                offText : "禁用",    // 设置OFF文本  
                onColor : "success",// 设置ON文本颜色     (info/success/warning/danger/primary)  
                offColor : "danger",  // 设置OFF文本颜色        (info/success/warning/danger/primary)  
                size : "mini",    // 设置控件大小,从小到大  (mini/small/normal/large)  
                handleWidth:"23",//设置控件宽度
                // 当开关状态改变时触发  
                onSwitchChange : function(event, state) {
                    var switchId = event.target.id;//获取当前switch的id
                    var showAll=$("#showAll").is(':checked');
                    if(showAll){
                        showAll='1';
                    }else{
                        showAll='0';
                    }
                    if (state == true) {
                        //启用当前版本 0-1
                        changeBbqy(switchId,'1',showAll,'启用');
                    } else {
                        //禁用当前版本 1-0
                        changeBbqy(switchId,'0',showAll,'禁用');
                    }
                }
            });

            var aa=treeNode.DESCRIPTION;
            if(aa==null){
                aa='';
            }
            $(".bootstrap-switch-id-"+treeNode.ID).attr('title',aa);
            //将根节点的switch放到右面
            $(".bootstrap-switch").attr('style','width: 72px;position:relative;float:right;');
        }

    }

    //根据版本开关修改是否启用
    function changeBbqy(id,status,isAll,msg) {
        $.post(ctx + "/schema/changeBbqy.action", {
            "id" : id,
            "status" : status
        }, function (json) {
            if(json.result){
                layer.msg(msg + "成功", {
                    icon : 1,
                    anim : 1
                });
                initSchemaTree(isAll);
                // if(isAll=='1'){
                //     $("#showAll").iCheck('check');
                // }
            }else{
                $.alert(json.message || "操作失败！", 2);
            }
        }, "json");
    }

    function addDiyDomAdd(treeId, treeNode) {
        var switchObj = $("#" + treeNode.tId + "_switch"),
            icoObj = $("#" + treeNode.tId + "_ico");
        switchObj.remove();
        icoObj.parent().before(switchObj);
        var spantxt = $("#" + treeNode.tId + "_span").html();
        if (spantxt.length > 10) {
            spantxt = spantxt.substring(0, 10) + "...";
            $("#" + treeNode.tId + "_span").html(spantxt);
        }
        $("#schemaTreeAdd .level0 ").attr('class','');
    }

    // 递归展开指定节点及其所有子节点
	function expandTreeNode(node) {
        var level = 0;
		level++;
		schemaTree.expandNode(node, true);
		if (level >= 3) {// 默认展开指定节点的第一级
			level = 0;
			return;
		}
		var children = node.CHILDREN;
		if (children) {
			$.each(children, function(i, item) {
				expandTreeNode(item);
			});
		}
	}

    // 递归展开指定节点及其所有子节点  新增版本时

    function expandTreeNodeAdd(node) {
        var levelAdd = 0;
        levelAdd++;
        schemaTreeAdd.expandNode(node, true);
        if (levelAdd >= 2) {// 默认展开指定节点的第一级
            levelAdd = 0;
            return;
        }
        var children = node.CHILDREN;
        if (children) {
            $.each(children, function(i, item) {
                expandTreeNodeAdd(item);
            });
        }
    }

    initSchemaTree('1');//默认显示已启用的
    var schemaTree;
    function initSchemaTree(status) {
        //每次初始化就讲存放上一个选中的节点记录清除掉
        selectNode=[];
        //左侧树形上方按钮默认无法使用
        $("#copySchemaBtn,#editSchemaBtn,#delSchemaBtn").hide();
        var schemaSetting = {
            data: {
                simpleData:{
                    enable: true
                },
                key: {
                    name: "NAME",
                    children: "CHILDREN",
                    title:""
                }
            },
            view: {
                selectedMulti: false,
                showTitle: true,
                addDiyDom: addDiyDom
            },
            edit: {
                enable: true,
                showRenameBtn: false,
                showRemoveBtn: false,
                drag: {
                    autoExpandTrigger: true,
                    isMove: true,
                    isCopy:false,
                    prev: function (treeId, nodes, targetNode) {
                        var pNode = targetNode.getParentNode();
                        if (pNode && pNode.TYPE == 2) {
                            return false;
                        }
                        return true;
                    },
                    inner: function (treeId, nodes, targetNode) {
                        if (targetNode && targetNode.TYPE == 2) {
                            return false;
                        }
                        return true;
                    },
                    next: function (treeId, nodes, targetNode) {
                        var pNode = targetNode.getParentNode();
                        if (pNode && pNode.TYPE == 2) {
                            return false;
                        }
                        return true;
                    }
                }
            },
            callback: {
                onClick: function (event, treeId, treeNode) {

                    // if (treeNode.TYPE == 2) {
                    //     currentNode = treeNode;
                    //     selectNode=treeNode;//节点切换成功后记录该节点
                    //     initRightForSchema(treeNode);
                    // }else{
                    //     initRight();//初始化右侧目录信息
                    //     selectNode=treeNode;//节点切换成功后记录该节点
                    // }

                    // 上一次选了目录节点切换时才校验
                    if(selectNode!=null && selectNode.TYPE==2 && selectNode.ID!=treeNode.ID){
                        // 校验部门及比对数据--页面数据和点击目录是保存的对应信息做比较 全部处理成字符串做比较
                        msg='';
                        flagXg=true;
                        var compareTime=$("#compareTime").is(':checked');
                        var compareSameDate=$("#compareSameDate").is(':checked');
                        if(compareTime){
                            compareTime='1';
                        }else{
                            compareTime='0';
                        }
                        if(compareSameDate){
                            compareSameDate='1';
                        }else{
                            compareSameDate='0';
                        }
                        var departmentNew=$("#department").val();
                        var isCheckDateNew=compareTime;
                        var isCheckRepeatNew=compareSameDate;
                        var beginDateCodeNew=$("#start").val();
                        var endDateCodeNew=$("#end").val();
                        var repeatCodesNew=$("#cfsj").val();
                        if(departmentNew!='' && departmentNew!=null){
                            departmentNew=departmentNew.toString();
                        }else{
                            departmentNew='';
                        }
                        if(repeatCodesNew!='' && repeatCodesNew!=null){
                            repeatCodesNew=repeatCodesNew.toString();
                        }else{
                            repeatCodesNew='';
                        }
                        if(beginDateCodeNew==null){
                            beginDateCodeNew='';
                        }
                        if(endDateCodeNew==null){
                            endDateCodeNew='';
                        }

                        var departmentOld='';
                        var isCheckDateOld='';
                        var isCheckRepeatOld='';
                        var beginDateCodeOld='';
                        var endDateCodeOld='';
                        var repeatCodesOld='';
                        if(oldDeptAndBdData[0]!=null){
                            if(oldDeptAndBdData[0].department!=null){
                                departmentOld=oldDeptAndBdData[0].department;
                            }
                        }
                        if(oldDeptAndBdData[1]!=null){
                            var bd=oldDeptAndBdData[1];
                            isCheckDateOld=bd.isCheckDate;
                            isCheckRepeatOld=bd.isCheckRepeat;
                            if(bd.beginDateCode!=null && bd.beginDateCode!=undefined){
                                beginDateCodeOld=bd.beginDateCode;
                            }else{
                                beginDateCodeOld='';
                            }
                            if(bd.endDateCode!=null && bd.endDateCode!=undefined){
                                endDateCodeOld=bd.endDateCode;
                            }else{
                                endDateCodeOld='';
                            }
                            if(bd.repeatCodes!=null && bd.repeatCodes!=undefined){
                                repeatCodesOld=bd.repeatCodes;
                            }else{
                                repeatCodesOld='';
                            }
                        }
                        if(departmentNew!=departmentOld){
                            var arr1=[];
                            var arr2=[];
                            if(departmentNew!='' && departmentNew!=null){
                                arr1=departmentNew.split(',');
                            }
                            if(departmentOld!='' && departmentOld!=null){
                                arr2=departmentOld.split(',');
                            }
                            if(arr1.length!=arr2.length){
                                flagXg=false;
                                msg=msg+'所属部门、';
                            }else{
                                for(var i=0;i<arr1.length;i++){
                                    if(!arr2.contains(arr1[i])){
                                        flagXg=false;
                                        msg=msg+'所属部门、';
                                    }
                                }
                            }
                        }
                        if(isCheckDateNew!=isCheckDateOld){
                            flagXg=false;
                            msg=msg+'时间比对勾选、';
                        }

                        if(isCheckRepeatNew!=isCheckRepeatOld){
                            flagXg=false;
                            msg=msg+'重复数据比对勾选、';
                        }
                        if(beginDateCodeNew!=beginDateCodeOld){
                            flagXg=false;
                            msg=msg+'时间比对选项1、';
                        }
                        if(endDateCodeNew!=endDateCodeOld){
                            flagXg=false;
                            msg=msg+'时间比对选项2、';
                        }
                        if(repeatCodesNew!=repeatCodesOld){
                            var arr1=[];
                            var arr2=[];
                            if(repeatCodesNew!='' && repeatCodesNew!=null){
                                arr1=repeatCodesNew.split(',');
                            }
                            if(endDateCodeOld!='' && endDateCodeOld!=null){
                                arr2=endDateCodeOld.split(',');
                            }
                            if(arr1.length!=arr2.length){
                                flagXg=false;
                                msg=msg+'重复数据比对、';
                            }else{
                                for(var i=0;i<arr1.length;i++){
                                    if(!arr2.contains(arr1[i])){
                                        flagXg=false;
                                        msg=msg+'重复数据比对、';
                                    }
                                }
                            }

                        }

                        //校验table列表是否修改
                        newTableData=[];
                        var selectedRows = table.rows('.active').data();
                        $.each(selectedRows, function (i, row) {
                            var copy = {};
                            copy = {"id" : row.id || 0};
                            copy["logicTableId"] = tableId;
                            copy["status"] = "1";
                            copy["isNullable"] = $("#" + row.id + "_isnullable").is(":checked") ? 0 : 1;
                            copy["requiredGroup"] = $.trim($("#" + row.id + "_requiredGroup").val());
                            copy["postil"] = encodeURI(row.postil || "");
                            copy["fieldSort"] = '0';
                            var str = JSON.stringify(row.ruleIdList || []);
                            copy["ruleIdListJson"] = str || "";
                            newTableData.push(copy);
                        });
                        if(newTableData.length!=oldTableData.length){
                            flagXg=false;
                            msg=msg+'指标选中数量、';
                        }else{
                            for(var i=0;i<newTableData.length;i++){
                                if(newTableData[i].id!=oldTableData[i].id){
                                    flagXg=false;
                                    msg=msg+'指标选中顺序、';
                                }else{
                                    var ts=i+1;
                                    if(newTableData[i].isNullable!=oldTableData[i].isNullable){
                                        flagXg=false;
                                        msg=msg+"指标必填第["+ts+']行、';
                                    }
                                    if(newTableData[i].postil!=encodeURI(oldTableData[i].postil || "")){
                                        flagXg=false;
                                        msg=msg+"指标备注第["+ts+']行、';
                                    }
                                    if(newTableData[i].requiredGroup!=oldTableData[i].requiredGroup){
                                        flagXg=false;
                                        msg=msg+"指标分组第["+ts+']行、';
                                    }
                                    if(newTableData[i].ruleIdListJson!=oldTableData[i].ruleIdListJson){
                                        flagXg=false;
                                        msg=msg+"指标规则第["+ts+']行、';
                                    }
                                }
                            }
                        }


                        //根据状态判断右侧页面有无修改
                        if(!flagXg){
                            layer.confirm(msg.substring(0,msg.length-1)+"处已修改未保存，确认离开吗？", {
                                icon : 3,
                                yes: function(index){
                                    oldDeptAndBdData=[];
                                    layer.close(index);
                                    //  点击左侧目录，初始化右侧内容
                                    if (treeNode.TYPE == 2) {
                                        currentNode = treeNode;
                                        //节点切换成功后记录该节点
                                        selectNode=treeNode;
                                        initRightForSchema(treeNode);
                                    }else{
                                        initRight();//初始化右侧目录信息
                                        selectNode=treeNode;
                                    }
                                }
                            }, function(){

                            }, function(){
                                //点击取消 节点选中恢复之前那个
                                schemaTree.selectNode(selectNode);

                            });
                        }else{
                            if (treeNode.TYPE == 2) {
                                currentNode = treeNode;
                                selectNode=treeNode;//节点切换成功后记录该节点
                                initRightForSchema(treeNode);
                            }else{
                                initRight();//初始化右侧目录信息
                                selectNode=treeNode;//节点切换成功后记录该节点
                            }
                        }
                    }else{
                        if (treeNode.TYPE == 2) {
                            currentNode = treeNode;
                            selectNode=treeNode;//节点切换成功后记录该节点
                            initRightForSchema(treeNode);
                        }else{
                            initRight();//初始化右侧目录信息
                            selectNode=treeNode;//节点切换成功后记录该节点
                        }
                    }







                    //控制选中版本时才显示复制、编辑、删除按钮
                    if(treeNode.isParent && treeNode.level=='0'){
                        $("#copySchemaBtn,#editSchemaBtn,#delSchemaBtn").show();
                        // $("#bbTs").show();
                    }else{
                        $("#copySchemaBtn,#editSchemaBtn,#delSchemaBtn").hide();
                        // $("#bbTs").hide();
                    }
                },
                //鼠标点到节点尝试拖拽时触发，在此限制版本节点以下所有节点禁止拖拽
                beforeDrag:function(treeId, treeNodes, targetNode, moveType, isCopy){
                    var curNode = treeNodes[0];
                    if (curNode) {
                        if(curNode.level != 0){
                            return false;
                        }
                    }
                    return true;
                },

                //根节点可以拖拽顺序
                beforeDrop: function (treeId, treeNodes, targetNode, moveType, isCopy) {
                    var curNode = treeNodes[0];
                    if (targetNode) {
                        if(targetNode.level == 0 && curNode.level==0 && moveType=='inner'){
                            $.alert("不同版本之间只可拖动顺序！");
                            return false;
                        }
                    }
                    return true;
                },
            }
        };
        schemaTree = $.fn.zTree.init($("#schemaTree"), schemaSetting, schemaNodes);
        //  查询资源目录树
        $.post(ctx + "/schema/getAllocationList.action",{
            "status":status //1-已启用  0-全部
        }, function (json) {
            if (schemaTree && json && json.length > 0) {
                schemaTree.addNodes(null, json);

                // 展开所有一层节点的第一级节点
                allNodes = schemaTree.transformToArray(schemaTree.getNodes());
                if (!isNull(allNodes)) {
                    expandTreeNode(allNodes[0]);//默认展开第一个节点及其子节点
                }
            }

        }, "json");
    }

    initSchemaTreeAdd();
    // 新增时初始化可供选择的目录树信息
    var schemaTreeAdd;
    var schemaNodesAdd = [];
    function initSchemaTreeAdd() {
        var schemaSettingAdd = {
            data: {
                simpleData:{
                    enable: true
                },
                key: {
                    name: "NAME",
                    children: "CHILDREN",
                    title:""
                }
            },
            check:{
                enable: true,
            },
            view: {
                selectedMulti: false,
                showTitle: true,
                addDiyDom: addDiyDomAdd
            },
            edit: {
                enable: true,
                showRenameBtn: false,
                showRemoveBtn: false,
                drag: {
                    autoExpandTrigger: true,
                    isMove: true,
                    isCopy:false,
                }
            }
        };
        schemaTreeAdd = $.fn.zTree.init($("#schemaTreeAdd"), schemaSettingAdd, schemaNodesAdd);
        //  查询资源目录树
        $.ajaxSettings.async = false;
        $.post(ctx + "/schema/getSchemaList.action", function (json) {
            if (schemaTreeAdd && json && json.length > 0) {
                schemaTreeAdd.addNodes(null, json);

                // 展开所有一层节点的第一级节点
                allNodesAdd = schemaTreeAdd.transformToArray(schemaTreeAdd.getNodes());
                if (!isNull(allNodesAdd)) {
                    $.each(allNodesAdd, function(i, item) {
                        if (item.level == 0) {// 展开所有一层节点的第一级节点
                            level = 0;
                            expandTreeNodeAdd(item);
                        }
                    });
                }
            }

        }, "json");
        $.ajaxSettings.async = true;
    }

    var oldSchemaText = "";
    //  资源目录树查询
    $("#searchSchemaTree").keyup(function() {
        $("#searchSchemaTreeMsg").hide();
        var val = $.trim($("#searchSchemaTree").val());
       var allNodes = schemaTree.transformToArray(schemaTree.getNodes());
        schemaTree.showNodes(allNodes);
        if (val != "") {
            var nodes = schemaTree.getNodesByParamFuzzy("NAME", val);

            if (nodes.length == 0) {
                $("#searchSchemaTreeMsg").show();
            }

            for (var i=0, len=nodes.length; i<len; i++) {
                var node = nodes[i];
                node["searchType"] = true;
                getParents(node);
            }

            for (var i=0, len=allNodes.length; i<len; i++) {
                var node = allNodes[i];
                if (!node["searchType"]) {
                    schemaTree.hideNode(node);
                } else {
                    node["searchType"] = false;
                }
            }
            schemaTree.expandAll(true);
        } else if (oldSchemaText != "") {
        	 schemaTree.expandAll(false);
         // 展开所有一层节点的第一级节点
        	allNodes = schemaTree.transformToArray(schemaTree.getNodes());
        	if (!isNull(allNodes)) {
        		$.each(allNodes, function(i, item) {
        			if (item.level == 0) {// 展开所有一层节点的第一级节点
        				level = 0;
        				expandTreeNode(item);
        			}
        		});
        	}
        }
        oldSchemaText = val;
    });


    //  获取父节点
    function getParents(node) {
        var parent = node.getParentNode();
        if (parent && !parent["searchType"]) {
            parent["searchType"] = true;
            getParents(parent);
        }
    }



    //  数据目录校验
    var tableValidator = $("#tableForm").validateForm({
        code: {
            required: true,
            rangelength:[2,50],//3.1.0 版本号
            // tableName: []
        },
        codeDesc: {
            maxlength: 400
        }
    });
    tableValidator.form();

    //  复制版本信息校验
    var tableCopyValidator = $("#tableFormCopy").validateForm({
        codeCopy: {
            required: true,
            rangelength:[2,50],//3.1.0 版本号
        }
    });
    tableCopyValidator.form();

    //	指标校验器
    var fieldValidator = $("#fieldForm").validateForm({
        name : {
            required:true,
            rangelength:[2,30],
            tableComment:[]
        },
        code : {
            required:true,
            rangelength:[2,30],
            tableName:[],
            keyword:[]
        },
        requiredGroup : {
            digits:true,
            min:1,
            max:99
        }
    }, ".innerSelect,.innerCheckbox");



    var flList=[];//存放分类信息
    var mlList=[];//存放目录信息
    //  保存版本配置
    function saveTable(index) {
        var zt=$("#sfqy").bootstrapSwitch('state');
        var nodes = schemaTreeAdd.getCheckedNodes();
        if(nodes.length<=0){
            $.alert("请选择目录！");
            return;
        }
        getCheckedResult(nodes);
    	if(zt){
            zt='1';
        }else{
            zt='0';
        }
        if (tableValidator.form()) {
            loading();
            $.post(ctx + "/schema/checkBbmc.action", {
                "bbmc":$("#code").val()
            }, function (json) {
                loadClose();
                if(json.result){
                    $.post(ctx + "/schema/allocationAdd.action", {
                        "fljson" : JSON.stringify(flList),
                        "mljson" : JSON.stringify(mlList),
                        "bbmc":$("#code").val(),
                        "bbms":$("#codeDesc").val(),
                        "isqy":zt
                    }, function (json) {
                        layer.close(index);
                        //清空
                        flList=[];
                        mlList=[];
                        if(json.result){
                            $.alert(json.message || "保存成功！", 1);
                            initSchemaTree('1');
                        }else{
                            $.alert(json.message || "保存失败！", 2);
                        }
                    }, "json");
                }else{
                    $.alert(json.message, 2);
                }
            }, "json");
        } else {
            $.alert("表单验证不通过！");
        }
    }

    //根据传进来的节点数据 分类处理成分类、目录数组
    function getCheckedResult(nodes) {
        flList=[];
        mlList=[];
        if(nodes!=null && nodes.length>0){
            for(var i=0;i<nodes.length;i++){
                var nodeCurrent=nodes[i];
                var isExistFather=nodeCurrent.isParent;
                if(nodeCurrent.isMl=='1'){
                    flList.push({
                        id : nodeCurrent.ID || ""
                    });
                }else{
                    mlList.push({
                        id : nodeCurrent.ID || ""
                    });
                }
            }
        }

    }

    //根据传进来的节点数据 获取目录id
    function getEditCheckedResult(node) {
        if(node.CHILDREN!=null && node.CHILDREN.length>0){
            var nodes=node.CHILDREN;
            for(var i=0;i<nodes.length;i++){
                var nodeCurrent=nodes[i];
                var isExistFather=nodeCurrent.isParent;
                if(isExistFather){//true--是父节点则是分类节点
                    getEditCheckedResult(nodeCurrent);
                }else{
                    mlList.push({
                        id : nodeCurrent.ID || ""
                    });
                }
            }
        }
    }

    //  更新版本配置
    function updateTable(index) {

        var zt=$("#sfqy").bootstrapSwitch('state');
        var nodes = schemaTreeAdd.getCheckedNodes();
        if(nodes.length<=0){
            $.alert("请选择目录！");
            return;
        }
        getCheckedResult(nodes);
        if(zt){
            zt='1';
        }else{
            zt='0';
        }

        if (true) {
            loading();
            $.post(ctx + "/schema/checkBbmc.action", {
                "bbmc":$("#code").val()
            }, function (json) {
                loadClose();
                if(true){
                    $.post(ctx + "/schema/allocationUpdate.action", {
                        "fljson" : JSON.stringify(flList),
                        "mljson" : JSON.stringify(mlList),
                        "bbid":$("#bbid").val(),
                        "bbmc":$("#code").val(),
                        "bbms":$("#codeDesc").val(),
                        "isqy":zt
                    }, function (json) {
                        layer.close(index);
                        //清空
                        flList=[];
                        mlList=[];
                        if(json.result){
                            var showAll=$("#showAll").is(':checked');
                            if(showAll){
                                showAll='1';
                            }else{
                                showAll='0';
                            }
                            $.alert(json.message || "保存成功！", 1);
                            initSchemaTree(showAll);
                        }else{
                            $.alert(json.message || "保存失败！", 2);
                        }
                    }, "json");
                }else{
                    $.alert(json.message, 2);
                }

            }, "json");


        } else {
            $.alert("表单验证不通过！");
        }
    }

    //  打开新增版本弹框
    $("#addTableBtn").click(function () {
        $(".wordsNum").html('0/400');
        //新增和修改共用，解决switch位置偏移，故销毁
        $("input[name='sfqy'][type='checkbox']").bootstrapSwitch('destroy');
        refreshTableDiv();
    	var allNodes = schemaTreeAdd.transformToArray(schemaTreeAdd.getNodes());
    	if(allNodes.length > 0){
            //点击新增版本按钮时初始化是否启用选项
            $("input[name='sfqy'][type='checkbox']").bootstrapSwitch({
                onText : "开启",      // 设置ON文本  
                offText : "禁用",    // 设置OFF文本  
                onColor : "success",// 设置ON文本颜色     (info/success/warning/danger/primary)  
                offColor : "danger",  // 设置OFF文本颜色        (info/success/warning/danger/primary)  
                size : "mini",    // 设置控件大小,从小到大  (mini/small/normal/large)  
                handleWidth:"25",//设置控件宽度
                state:false,
            });
    		$.openWin({
    			title: "新增版本",
    			content: $("#tableDiv"),
    			area: ['50%', '85%'],
    			yes: function (index) {
    				saveTable(index);
    				
    			}
    		});
    		tableValidator.form();
    	}else{
    		  $.alert("请先添加上报配置！");
    	}
    });

    $('#codeDesc').on('input propertychange', function () {

        //获取输入内容
        var userDesc = $(this).val();
        //判断字数
        var len;
        if (userDesc) {
            len = checkStrLengths(userDesc, 400);
        } else {
            len = 0
        }
        //显示字数
        $(".wordsNum").html(len + '/400');
    });

    var checkStrLengths = function (str, maxLength) {
        var maxLength = maxLength;
        var result = 0;
        if (str && str.length > maxLength) {
            result = maxLength;
        } else {
            result = str.length;
        }
        return result;
    }

    //  修改数据归集信息配置
    $("#editSchemaBtn").click(function () {
        flList=[];
        mlList=[];
        var nodes = schemaTree.getSelectedNodes();
        if (nodes && nodes.length > 0) {
            var node = nodes[0];
            if (node) {
                openAllocationEditWin(node);
            }
        } else {
            $.alert("请选择要修改的版本！");
        }
    });

    //  打开归集信息配置修改弹窗
    function openAllocationEditWin(node) {
        //新增和修改共用，解决switch位置偏移，故销毁
        $("input[name='sfqy'][type='checkbox']").bootstrapSwitch('destroy');
        refreshTableDiv();
        $("#tableForm")[0].reset();
        $("#bbid").val(node.ID);//版本id
        $("#code").val(node.NAME);//版本名称
        if(node.DESCRIPTION!=null){
            $("#codeDesc").val(node.DESCRIPTION);//版本描述
            $(".wordsNum").html(node.DESCRIPTION.length+'/400');
        }
        var mlArr=[];
        if(node!=null && node.CHILDREN!=null){
            var nodes=node.CHILDREN;
            mlList=[];
            getEditCheckedResult(node);
        }
        var addCheck;
        for(var i=0;i<mlList.length;i++){
            addCheck = schemaTreeAdd.getNodeByParam( "ID",mlList[i].id,null)
            schemaTreeAdd.checkNode(addCheck, true, true);
        }

        if(node.STATUS=='1'){//启用
            $("input[name='sfqy'][type='checkbox']").bootstrapSwitch({
                onText : "开启",      // 设置ON文本  
                offText : "禁用",    // 设置OFF文本  
                onColor : "success",// 设置ON文本颜色     (info/success/warning/danger/primary)  
                offColor : "danger",  // 设置OFF文本颜色        (info/success/warning/danger/primary)  
                size : "mini",    // 设置控件大小,从小到大  (mini/small/normal/large)  
                handleWidth:"25",//设置控件宽度
                state:true,
            });
        }else{
            $("input[name='sfqy'][type='checkbox']").bootstrapSwitch({
                onText : "开启",      // 设置ON文本  
                offText : "禁用",    // 设置OFF文本  
                onColor : "success",// 设置ON文本颜色     (info/success/warning/danger/primary)  
                offColor : "danger",  // 设置OFF文本颜色        (info/success/warning/danger/primary)  
                size : "mini",    // 设置控件大小,从小到大  (mini/small/normal/large)  
                handleWidth:"25",//设置控件宽度
                state:false,
            });
        }
        tableValidator.form();
        //点击修改版本按钮时初始化是否启用选项

        $.openWin({
            title: "修改归集信息",
            content: $("#tableDiv"),
            area: ['50%', '85%'],
            yes: function (index) {
                updateTable(index);
            }
        });
    }

    //清空tableDiv内容，ztree和switch重新初始化
    function refreshTableDiv() {
        $("#code").val('');
        $("#codeDesc").val('');
        schemaTreeAdd.destroy();
        initSchemaTreeAdd();
    }

    //删除选中版本
    $("#delSchemaBtn").click(function () {
        var nodes = schemaTree.getSelectedNodes();


        if (nodes && nodes.length > 0) {
            var node = nodes[0];
            $.post(ctx + "/schema/checkIsBssj.action", {
                "bbId" : node.ID
            }, function (json) {
                if(json.result){
                    if(json.message=='1'){
                        $.alert("存在已报送数据，无法删除", 2);
                    }else{
                        if (node) {
                            layer.confirm("确认删除该版本吗？", {
                                icon : 3,
                            }, function(index) {
                                layer.close(index);
                                $.post(ctx + "/schema/deleteBb.action", {
                                    "id" : node.ID
                                }, function (json) {
                                    if(json.result){
                                        layer.msg("删除成功", {
                                            icon : 1,
                                            anim : 1
                                        });
                                        initSchemaTree('1');
                                    }else{
                                        $.alert(json.message || "操作失败！", 2);
                                    }
                                }, "json");

                            });
                        }
                    }
                }else{
                    $.alert("查询报送数据失败", 2);
                }
            }, "json");
        } else {
            $.alert("请选择要删除的版本！");
        }
    });

    //复制版本
    $("#copySchemaBtn").click(function () {
        $("#codeCopy").val('');
        tableCopyValidator.form();
        $.openWin({
            title: "复制版本信息",
            content: $("#tableDivCopy"),
            area: ['40%', '30%'],
            yes: function (index) {
                var nodes = schemaTree.getSelectedNodes();
                if (nodes && nodes.length > 0) {
                    var node = nodes[0];
                    if (node) {
                        if(tableCopyValidator.form()){
                            $.post(ctx + "/schema/checkBbmc.action", {
                                "bbmc":$("#codeCopy").val()
                            }, function (json) {
                                if(json.result){
                                    loading();
                                    $.post(ctx + "/schema/copyBb.action", {
                                        "id" : node.ID,
                                        "codeCopy" : $("#codeCopy").val()
                                    }, function (json) {
                                        loadClose();
                                        if(json.result){
                                            layer.close(index);
                                            layer.msg("复制成功", {
                                                icon : 1,
                                                anim : 1
                                            });
                                            var showAll=$("#showAll").is(':checked');
                                            if(showAll){
                                                showAll='1';
                                            }else{
                                                showAll='0';
                                            }
                                            initSchemaTree(showAll);
                                        }else{
                                            $.alert(json.message || "操作失败！", 2);
                                        }
                                    }, "json");
                                }else{
                                    $.alert(json.message, 2);
                                }
                            }, "json");


                        }else{
                            $.alert("表单验证不通过！");
                        }
                    }
                } else {
                    $.alert("请选择要复制的版本！");
                }
            }
        });
    });

    //初始化目录信息
    function initRight(){
    	 table.clear().draw();
        $("#compareTime").iCheck('uncheck');
        $("#compareSameDate").iCheck('uncheck');
        $("#start option").remove();
        $("#end option").remove();
        $("#cfsj").cclSelectRemove();
        $("#cfsj").cclSelect({
            data : '',

        });
        //  初始化目录名称、编码、授权部门等信息
        $("#department").val("");
        $("#departments").val("");
        $(".ccl-multi-select-li").remove();
        $(".ccl-multi-select-active").removeClass("ccl-multi-select-active");
         $("#saveBtn").attr("disabled", "disabled");
    }
    
 // 查询部门列表
	$.getJSON(ctx + "/system/department/getDeptList.action", function(result) {
		// 初始化协同部门
		$("#department").cclSelect({
			data : result,
			change : function() {
				//validator.element($("#departments"));
			},
			beforeDel : function(k, v) {
                var nodes = schemaTree.getSelectedNodes();
                log(nodes)
                if (nodes && nodes.length > 0) {
                    var node = nodes[0];
                    if (node) {
                        var flag = true;
                        $.ajax({
                        	type : "POST",
                        	dataType : 'json',
                        	url : ctx + '/schema/getDataCount.action',
                        	data : {
                                code: node.CODE,
                                deptId: k,
                                versionId:node.TABLE_VERSION_ID
                        	},
                        	async : false,
                        	success : function(rs) {
                        		if (rs && rs.result && rs.message > 0) {
                                	  $.alert(rs.deptName+"在该目录中已有上报数据，不能移除！", 2);
                                	  flag = false;
                                  }else{
                                	  flag= true;
                                  }
                        	}
                        });
                        return flag;
                    }
                } else {
                    $.alert("请选择要修改的版本！");
                }

			}
		});		
	});

    //创建一个Datatable
    var table = $('#dataTable').DataTable({
        ordering: true,
        order: [[0, 'asc']],
        searching: false,
        autoWidth: false,
        lengthChange: false,
        pageLength: 10,
        serverSide: false,//如果是服务器方式，必须要设置为true
        processing: true,//设置为true,就会有表格加载时的提示
        paging: false,
        rowId: 'staffId',
        columns: [{
            "data": null,
            "orderable": false
            },
            {"data" : null, "render": function(data, type, full) {
                var imgUrl = ctx + "/app/images/schema/dragImg.png";
                var op = "<img src='" +imgUrl+ "' style='cursor: all-scroll;'/>";
                return op;
            }},
            {"data": "name", "render": fmtName},
            {"data": "code", "render": fmtCode},
            {"data": "len", "render": fmtLength},
            {"data": "isNullable", "render": fmtNullable},
            {"data": "requiredGroup", "render": fmtGroup},
            {"data" : "ID", "render": function(data, type, full) {
                    var add = full.mappedCode || 0;
                    var op = "<input type='hidden' class='rowsId' value='" + full.id + "'/><a href='javascript:;' onclick='al.openRuleWin(\"" + full.id + "\")'>规则</a>&nbsp;&nbsp;";
                    return op;
                }},
            {"data": "postil", "render": fmtPostil}
        ],
        columnDefs: [{
            targets: 0, // checkBox
            render: function (data, type, row) {
                data = data.mappedCode || 0;
                return "<input type='checkbox'"+ (data == 0 ? "" : "checked='checked'")
                    + "value='" + row.id + "'"
                    + "id='" + row.id + "_addOption'"
                    + "code='" + row.code + "'"
                    + "option='" + row.name + "'"
                    + "columnType='" + row.type + "'"
                    + "name='checkThis' class='icheck'>";
            }
        }],
        initComplete: function () {
            var $btns = $("#fieldBtns");
            $("#schemaDiv div.ttop").append($btns);
            $btns.show();
        },
        drawCallback: function (settings) {
            var check_id = $("#check_id").val();
            if (!isNull(check_id)) {
                // $("#" + check_id).parents().find("tr").removeClass("active");
                $("#" + check_id).parent().parent().parent().addClass("active");
            }

            //	隐藏排序图标、解绑表头排序功能
            var $th = $("#fieldForm").find("th.sorting_desc,th.sorting,th.sorting_asc");
            $th.removeClass("sorting_desc sorting sorting_asc");
            $th.unbind("click");
            $th.css("outline", "none");
            $th.css("cursor", "auto");

            //	重置按钮状态
            var $tr = $("#dataTable tbody tr[role='row']");
            $tr.find("div.sort-top").css("background-position", "7px -14px");
            $tr.find("div.sort-up").css("background-position", "-37px -14px");
            $tr.find("div.sort-down").css("background-position", "-60px -14px");
            $tr.find("div.sort-bottom").css("background-position", "-17px -14px");
            $tr.find("div.field-sort").css("cursor", "pointer");

            //	第一行置顶、上移置灰
            $tr.filter(":first").find("div.sort-top").css("background-position", "7px 9px");
            $tr.filter(":first").find("div.sort-up").css("background-position", "-37px 9px");
            $tr.filter(":first").find("div.sort-top").css("cursor", "auto");
            $tr.filter(":first").find("div.sort-up").css("cursor", "auto");

            //	最后一行置底、下移置灰
            $tr.filter(":last").find("div.sort-down").css("background-position", "-60px 9px");
            $tr.filter(":last").find("div.sort-bottom").css("background-position", "-17px 9px");
            $tr.filter(":last").find("div.sort-down").css("cursor", "auto");
            $tr.filter(":last").find("div.sort-bottom").css("cursor", "auto");

            $('#checkall, #dataTable tbody input[name="checkThis"][type="checkbox"]').iCheck({
                labelHover: false,
                cursor: true,
                checkboxClass: 'icheckbox_square-blue',
                radioClass: 'iradio_square-blue',
                increaseArea: '20%'
            });
            // 列表复选框选中取消事件
            var checkAll = $('#checkall');
            var checkboxes = $('#dataTable tbody input[name="checkThis"][type="checkbox"][id!="checkall"]');
            checkAll.on('ifChecked ifUnchecked', function (event) {
                sfpx=false;
                if (event.type == 'ifChecked') {
                    checkboxes.iCheck('check');
                } else {
                    checkboxes.iCheck('uncheck');
                }
            });
            checkboxes.on('ifChanged', function (event) {
                sfpx=true;
                if (checkboxes.filter(':checked').length == checkboxes.length) {
                    checkAll.prop('checked', 'checked');
                } else {
                    checkAll.removeProp('checked');
                }
                checkAll.iCheck('update');
                if ($(this).is(':checked')) {
                    $(this).closest('tr').addClass('active');
                    $(this).closest('tr').addClass('active1');
                    // $(this).closest('tr').find('input[name="dataOrder"][type="radio"], .innerSelect').prop('disabled', false);
                } else {
                    $(this).closest('tr').removeClass('active');
                    $(this).closest('tr').removeClass('active1');
                    // $(this).closest('tr').find('input[name="dataOrder"][type="radio"], .innerSelect').prop('disabled', true);
                }
            });
        }
    });

    //	规则管理
	function openRuleWin(id) {
		$("#rowId").val(id);
		$("#ruleDiv input.rule").removeAttr("checked");
		var row = getRowById(id);
		var ruleIdList = row.ruleIdList || [];
		for (var i=0; i<ruleIdList.length; i++) {
			var ruleId = ruleIdList[i];
			$("#" + ruleId).prop("checked", "checked");
		}
		$.openWin({
			title: "规则管理",
			content: $("#ruleDiv"),
			yes: function(index) {
				layer.close(index);
				changeRule();
			}
		});
	}
	
//	改变字段规则
	function changeRule() {
		var $rules = $("#ruleDiv input.rule");
		var rowId = $("#rowId").val();
		var row = getRowById(rowId);
		if (row) {
			var ruleIdList = row.ruleIdList || [];
			var newRuleIdList = [];
			$.each($rules, function(i, obj) {
				var ruleId = $(obj).attr("id");
				if ($(obj).is(":checked")) {	//	选中的
					newRuleIdList.push(ruleId);
				}
			});
			row.ruleIdList = newRuleIdList;
		}
	}

    //  单击行显示焦点
    $('#dataTable tbody').on('click', 'tr', function() {
        if (!$(this).hasClass('active')) {
            // table.$('tr.active').removeClass('active');
            // $(this).addClass('active');
        }
    });

    //	格式化指标名称
    function fmtName(data, type, full) {
        data = data || "";
        var dis = full.add == 1 ? "" : "disabled='true'";
        dis = full.commonFieldId ? "disabled='true'" : dis;
        return "<div class='input-icon right'><i class='fa'></i>"
            + "<input type='text' class='innerInput innerInputName form-control' value='"
            + data + "' id='" + full.id + "_name' name='name' " + dis + " /></div>";
    }

    //	格式化指标编码
    function fmtCode(data, type, full) {
        data = data || "";
        var dis = full.add == 1 ? "" : "disabled='true'";
        dis = full.commonFieldId ? "disabled='true'" : dis;
        return "<div class='input-icon right'><i class='fa'></i>"
            + "<input type='text' class='innerInput innerInputCode form-control' value='"
            + data + "' id='" + full.id + "_code' name='code' " + dis + " /></div>";
    }


    //	格式化指标长度
    function fmtLength(data, type, full) {
        data = data || "";

        var cls = full.add == 1 ? "add" : "";
        var dis = full.add == 1 ? "" : "disabled='true'";
        dis = full.commonFieldId ? "disabled='true'" : dis;
        return "<div class='input-icon right'><i class='fa'></i>"
            + "<input type='text' class='form-control innerInput innerInputLen "
            + cls + "' value='" + data + "' name='len" + full.id + "' id='"
            + full.id + "_len' " + dis + " /></div>";
    }

    //	格式化指标是否必填
    function fmtNullable(data, type, full) {
        data = data || 0;

        return "<input type='checkbox'"+ (data == 0 ? "checked='checked'" : "")
            + "value='" + full.id + "'"
            + "id='" + full.id + "_isnullable'"
            + "name='"+full.name+"' class='innerCheckbox'>";
    }

    //	格式化分组
    function fmtGroup(data, type, full) {
        var isNullable = full.isNullable || 0;
        data = data || "";
        return "<div class='input-icon right'><i class='fa'></i>"
            + "<input type='text' class='innerInput innerInputGroup form-control' value='"
            + data + "' id='" + full.id + "_requiredGroup' name='requiredGroup'  /></div>";
    }

    //	格式化批注
    function fmtPostil(data, type, full) {
        data = data || "";
        var icon = data ? "fa-file-text-o" : "fa-file-o";
        return "<div style='text-align:center;'><i class='fa " + icon + "' id='"
            + full.id + "_postil' style='cursor:pointer;' title='" + data + "' "
            + "onclick='al.openPostilWin(this, \"" + full.id + "\")'></i></div>";
    }

    //	格式化指标状态
    function fmtStatus(data, type, full) {
        var value = full.status || 0;
        var op = "<select class='form-control innerSelect' id='" + full.id + "_status'>"
            + "    <option value='1' " + (value == 1 ? "selected='selected'" : "") + ">有效</option>"
            + "    <option value='0' " + (value == 0 ? "selected='selected'" : "") + ">无效</option>"
            + "</select>";
        return op;
    }



    //	勾选必填时，启用禁用分组输入框
    function changeGroup(id,name) {
        var bool = $("#" + id + "_isnullable").is(":checked");
        // if (bool) {
        //     $("#" + id + "_requiredGroup").removeAttr("disabled");
        // } else {
        //     $("#" + id + "_requiredGroup").val("");
        //     $("#" + id + "_requiredGroup").attr("disabled", "disabled");
        // }
        //列表中选中或取消时对应修改数据库
        // $.post(ctx + "/schema/changeColumnStatus.action", {
        //     columnId : id
        // }, function (json) {
        //
        // }, "json");

    }

    //	初始化checkbox 样式和选中或取消事件
    function initCheckbox($obj) {
        //控制必选项checkbox
        if (!$obj) {
            $obj = $("#dataTable input.innerCheckbox");
        }
        $obj.iCheck({
            labelHover : false,
            checkboxClass : 'icheckbox_square-blue',
            radioClass : 'iradio_square-blue',
            increaseArea : '20%'
        });
        $(".icheckbox_square-blue").css("margin-right", "0px");
        $obj.on('ifChanged', function(event){
            changeGroup($(this).val(),$(this).attr('name'));
        });
        //控制table左侧checkbox
        var leftCheckboxs = $("#dataTable input[name='checkThis'][id!='checkall']");
        leftCheckboxs.on('ifChanged', function(event){
            sfpx=true;
            addOrDeleteOption($(this).attr('id'),$(this).attr('code'),$(this).attr('option'),$(this).attr('columnType'));
        });
        table.$('td.sorting_1 > div.checked').parent().parent().addClass('active');
    }
    //根据column列表左侧checkbox选中与否动态添加或删除选项内容
    function addOrDeleteOption(id,code,name,type) {
        var isChecked = $("#" + id).is(":checked");
        if (isChecked) {
            if(id=='checkall'){
                return false;
            }else{
                if(type=='DATE'){
                    $("#start,#end").append("<option value='"+code+"'>"+name+"</option>");
                }
                $("#cfsj").cclSelectAddData({
                    data: [
                        {id: code, text: name},
                    ]
                });
            }
        } else {
            if(id=='checkall'){
                return false;
            }else{
                if(type=='DATE'){
                    $("#start option[value='"+code+"'],#end option[value='"+code+"']").remove();
                }
                $("#start,#end").val([]).trigger('change');//重新渲染
                $("#cfsj").cclSelectRemoveData({
                    data: [{id: code, text: name}]
                });
                $("#cfsj > option[value="+code+"]").attr("selected",false);
            }

        }
        //11
        // if(sfpx){
        //     log("排序了")
        //     checkedSort();
        // }
    }
    function initFieldList() {
        oldTableData=[];//每次成功点击目录节点时先把对象清空
        //	查询指标列表
        $.post(ctx + "/schema/getBbFieldList.action", {
            id : tableId,
            "dp_table_version_config_id":dp_table_version_config_id,
        }, function(json) {
            if (json && json.list) {
                table.clear().draw();
                sortNum = json.list.length || 0;
                if (sortNum > 0) {
                    table.rows.add(json.list);
                    for (var i=0; i<sortNum; i++) {
                        sortList.push(i);
                        table.cell(i, 0).data(i);


                        if(json.list[i].mappedCode!='' && json.list[i].mappedCode!=null){
                            var row=json.list[i];
                            var copy = {};
                            copy = {"id" : row.id || 0};
                            copy["isNullable"] = row.isNullable || "";
                            copy["requiredGroup"] = row.requiredGroup || "";
                            copy["postil"] = row.postil || "";
                            copy["ruleIdListJson"] = JSON.stringify(row.ruleIdList || []);
                            oldTableData.push(copy);
                        }
                    }
                    table.draw();
                    $(".innerType").trigger("change");
                    fieldValidator.form();
                    initCheckbox();
                }
            }
        }, "json");
    }

    //	批注管理
    function openPostilWin(obj, id) {
        $("#postilDiv").data("id", id);
        $("#postilDiv").data("obj", obj);
        var row = getRowById(id);
        $("#postil").val(row.postil || "");
        setTimeout(function(){document.getElementById("postil").focus();}, 200);
        $.openWin({
            title: "批注管理",
            content: $("#postilDiv"),
            yes: function(index) {
                var text = $.trim($("#postil").val());
                if (text && text.length > 200) {
                    $.alert("批注不能超过200个字符！");
                    return;
                }
                layer.close(index);
                changePostil();
            }
        });
    }

    //	修改批注
    function changePostil() {
        var id = $("#postilDiv").data("id");
        var obj = $("#postilDiv").data("obj");
        var row = getRowById(id);
        if (row && obj) {
            var text = $.trim($("#postil").val());
            row.postil = text || "";
            if (text) {
                $(obj).removeClass("fa-file-o").addClass("fa-file-text-o");
                $(obj).attr("title", text);
            } else {
                $(obj).removeClass("fa-file-text-o").addClass("fa-file-o");
                $(obj).attr("title", text);
            }
        }
    }

    //	根据ID获取一行数据
    function getRowById(id) {
        var rows = table.data();
        for (var i=0; i<rows.length; i++) {
            var row = rows[i];
            if (row.id == id) {
                return row;
            }
        }
    }

    

    //	改变指标规则
    function changeRule() {
        var $rules = $("#ruleDiv input.rule");
        var rowId = $("#rowId").val();
        var row = getRowById(rowId);
        if (row) {
            var ruleIdList = row.ruleIdList || [];
            var newRuleIdList = [];
            $.each($rules, function(i, obj) {
                var ruleId = $(obj).attr("id");
                if ($(obj).is(":checked")) {	//	选中的
                    newRuleIdList.push(ruleId);
                }
            });
            row.ruleIdList = newRuleIdList;
        }
    }

    //	选中规则
    function selectRule(obj) {
        var event = window.event || arguments.callee.caller.arguments[0];
        if (!$(event.target).is(".rule")) {
            var $checkbox = $(obj).find("input.rule");
            $checkbox.trigger("click");
        }
    }

    //	校验是否存在相同的编码
    function checkSameCode() {
        var map = {};
        var list = table.data();
        for (var i=0, len=list.length; i<len; i++) {
            var row = list[i];
            var code = $("#" + row.id + "_code").val();
            code = code.toUpperCase();
            if (!map[code]) {
                map[code] = true;
            } else {
                $("#" + row.id + "_code").trigger("click");
                $.alert("指标编码[" + code + "]重复！", 0, function() {
                    $("#" + row.id + "_code").focus();
                });
                return false;
            }
        }
        return true;
    }

    //	整数要提交的数据
    function disposalData() {

        checkedList=[];
        var selectedRows = table.rows('.active').data();
        $.each(selectedRows, function (i, row) {
            var copy = {};
            copy = {"id" : row.id || 0};
            copy["logicTableId"] = tableId;
            copy["status"] = "1";
            copy["isNullable"] = $("#" + row.id + "_isnullable").is(":checked") ? 0 : 1;
            copy["requiredGroup"] = $.trim($("#" + row.id + "_requiredGroup").val());
            copy["postil"] = encodeURI(row.postil || "");
            // todo 添加拖拽顺序
            copy["fieldSort"] = '0';
            var str = JSON.stringify(row.ruleIdList || []);
            copy["ruleIdListJson"] = str || "";
            checkedList.push(copy);
        });

        //重新排序--取出table列表所有列的id(顺序是按照列表行顺序)，根据选中的行id去其中找对应的下标并赋值给对应的fieldSort
        var $inputs = $("#dataTable tr .rowsId");
        var sortIdArr = [];
        $inputs.each(function (i) {
            sortIdArr[i] = $(this).val();
        })
        if(checkedList.length>0){
            for(var i=0;i<checkedList.length;i++){
                var checkedId=checkedList[i].id;
                if(sortIdArr.length>0){
                    for(var j=0;j<sortIdArr.length;j++){
                        if(checkedId==sortIdArr[j]){
                            checkedList[i].fieldSort=j;
                        }
                    }
                }
            }
        }

        //0 勾选  1-未勾选
        //保存的字段中  如果其中只有一个勾选了必填，其他字段未勾选必填
        var numIsNullAble=0;
        var numRequiredGroup=0;
        var arr1=[];//存放勾选必填的数组
        var arr2=[];//存放未勾选必填的数组
        if(checkedList.length>0){
            for(var i=0;i<checkedList.length;i++){
                var nullable=checkedList[i].isNullable;
                    if(nullable=='0'){
                        numIsNullAble++;
                    }
            }
            if(numIsNullAble==1){
                for(var i=0;i<checkedList.length;i++){
                    var nullable=checkedList[i].isNullable;
                    if(nullable=='0'){
                        arr1.push(checkedList[i]);
                    }else{
                        arr2.push(checkedList[i]);
                    }
                }
                //勾选必填字段未填写时，其余字段任填其一满足规则
                if(arr1[0].requiredGroup==''){
                    if(arr2.length>0){
                        for(var i=0;i<arr2.length;i++){
                            if(arr2[i].requiredGroup!=''){
                                numRequiredGroup++;
                            }
                        }
                        if(numRequiredGroup!=1){
                            $.alert("勾选必填字段未填写时，其余字段任填其一", 2);
                            return false;
                        }
                    }
                }
                //勾选必填字段填写时，其余字段必须全部不填写满足规则
                if(arr1[0].requiredGroup!=''){
                    if(arr2.length>0){
                        for(var i=0;i<arr2.length;i++){
                            if(arr2[i].requiredGroup!=''){
                                numRequiredGroup++;
                            }
                        }
                        if(numRequiredGroup!=0){
                            $.alert("勾选必填字段填写时，其余字段必须全部不填写", 2);
                            return false;
                        }
                    }
                }
            }
        }
        return true;
    }

    //	保存数据
    function saveFieldList() {
    		if (fieldValidator.form()) {
                // if (!checkSameCode()) {
                //     return;
                // }
                var dep=$("#department").val();
                var sjbd1=$("#start").val();
                var sjbd2=$("#end").val();
                var cfsj1=$("#cfsj").val()
                var compareTime=$("#compareTime").is(':checked');
                var compareSameDate=$("#compareSameDate").is(':checked');
                if (!disposalData()) {
                    return;
                }
                if(compareTime){
                    if(sjbd1!=null && sjbd1!='' && sjbd2!=null && sjbd2!=''){
                        if($("#start").val()==$("#end").val()){
                            $.alert('时间比对两个选项不能重复！');
                            return;
                        }
                    }
                }
                var checked = table.rows('.active').data();
                if(checked.length<1){
                    $.alert('指标项至少勾选一个！');
                    return;
                }
                // if($("#department").val()==null){
                //     $.alert('请选择机构！');
                //     return;
                // }
                loading();

                if(compareTime){
                    compareTime='1';
                }else{
                    compareTime='0';
                    sjbd1='';
                    sjbd2='';
                }
                if(compareSameDate){
                    compareSameDate='1';
                }else{
                    compareSameDate='0';
                    cfsj1=null;
                }

                var repeatCodes=[];
                repeatCodes=$("#cfsj").val();
                // 提交数据
                $.post(ctx + "/schema/saveBbFieldList.action", {
                    "id" : dp_table_version_config_id,
                    "isCheckDate" :compareTime,
                    "isCheckRepeat" : compareSameDate,
                    "beginDateCode" : sjbd1,
                    "endDateCode" : sjbd2,
                    "repeatCodes" : JSON.stringify(cfsj1),
                    "deptId" : JSON.stringify(dep),
                    "tableVersionId" : tableVersionId,
                    "logicTableId" : tableId,
                    "dp_table_version_config_id" : dp_table_version_config_id,
                    "checkedList" : JSON.stringify(checkedList),
                }, function(data) {
                    loadClose();
                    if (data.result) {
                        $.alert('保存成功！', 1, function() {
                            oldDeptAndBdData=[];
                        	initRightForSchema(currentNode);
                            checkedList = [];
                        });
                    } else {
                        $.alert(data.message || "保存失败！", 2);
                    }
                }, "json");
            } else {
                $.alert('表单验证不通过！');
            }
        
    }

    $("#saveBtn").click(function() {
        saveFieldList();
    });
    $(function () {
        $('#dataTable').sortable({
            containerSelector: 'table',
            itemPath: '> tbody',
            itemSelector: 'tr',
            placeholder: '<tr class="placeholder"/>',
            onDrop: function ($item, container, _super, event) {
                $item.removeClass(container.group.options.draggedClass).removeAttr("style");
                $("body").removeClass(container.group.options.bodyClass);
                // $item.parent().find("tr").removeClass("active");
                var id_name = $item.find("input[name='name']").attr("id");
                $("#check_id").val(id_name);
                // $item.addClass("active");
                var flag = false;
                //  单击行显示焦点
                $('#dataTable tbody').on('click', 'tr', function () {
                    // $(this).parent().find("tr").removeClass("active");
                    // $(this).addClass('active');
                });
            }
        })
    })


    function checkedSort() {
        var checkedLine=[];
        var list= table.data();
        checkedList=[];
        var selectedRows = table.rows('.active').data();
        $.each(selectedRows, function (i, row) {
            var copy = {};
            copy = {"id" : row.id || 0};
            checkedList.push(copy);
        });

        for(var i=0;i<list.length;i++){
            for(var j=0;j<checkedList.length;j++){
                if(checkedList[j].id==list[i].id){
                    checkedLine.push(list[i]);
                }
            }
        }
        for(var i=0;i<checkedLine.length;i++){
            checkedLine[i].mappedCode='1';
        }
        list=[];
        for(var i=0;i<checkedLine.length;i++){
            list.push(checkedLine[i]);
        }
        //获取未被勾选的指标选项
        $.ajaxSettings.async = false;
        $.post(ctx + "/schema/getBbFieldYdList.action", {
            id : tableId,
            "dp_table_version_config_id":dp_table_version_config_id,
            checkedList : JSON.stringify(checkedList)
        }, function(json) {
            if (json && json.list) {
                table.clear().draw();
                sortNum = json.list.length || 0;
                if (sortNum > 0) {
                    for (var i=0; i<sortNum; i++) {
                        list.push(json.list[i])
                    }
                }
            }
        }, "json");
        $.ajaxSettings.async = true;


        for(var i=0;i<checkedLine.length;i++){
            if(checkedLine[i].mappedCode!='' && checkedLine[i].mappedCode!=null){
                var row=checkedLine[i];
                var copy = {};
                copy = {"id" : row.id || 0};
                copy["isNullable"] = row.isNullable || "";
                copy["requiredGroup"] = row.requiredGroup || "";
                copy["postil"] = row.postil || "";
                copy["ruleIdListJson"] = JSON.stringify(row.ruleIdList || []);
                oldTableData.push(copy);
            }
        }

        table.clear().draw();
        sortNum = list.length || 0;
        if (sortNum > 0) {
            table.rows.add(list);
            for (var i=0; i<sortNum; i++) {
                sortList.push(i);
                table.cell(i, 0).data(i);

            }
            table.draw();
            $(".innerType").trigger("change");
            fieldValidator.form();
            initCheckbox();
        }
    }



    return {
    	openRuleWin:openRuleWin,
        openPostilWin : openPostilWin,
        selectRule : selectRule
    };

})();






