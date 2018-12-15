var sl = (function () {

    // 组织冒泡事件，防止点击事件和拖动事件冲突
    window.setTimeout(function () {
        try {
            stopBubble();
        } catch (e) {

        }
    }, 1500);

    $('#switch').bootstrapSwitch();
    $("#addBtn_JC,#saveBtn_JC").attr("disabled", "disabled");
    var oldDepts;

    var tableId = null;	    //	表ID
    var tableCode = null;   // table code
    var dataCount = 0;	    //	表中数据数量
    var addList = [];	    //	添加的指标列表(只保存数据库中不存在的记录)
    var delList = [];	    //	删除的指标列表(只保存数据库中已存在的记录)
    var modList = [];	    //	修改名称、编码、必填、状态的列表(只保存数据库中已存在的记录)
    var nameList = [];	    //	修改名称的列表(只保存数据库中已存在的记录)
    var codeList = [];	    //	修改编码的列表(只保存数据库中已存在的记录)
    var sortNum = 0;	    //	排序序号
    var sortList = [];	    //	排序列表

    var schemaNodes = [];
    var fieldNodes = [];
    var classifyNodes = [];
    var currentNode;

    var schemaSetting = {
        data: {
            simpleData: {
                enable: true
            },
            key: {
                name: "NAME",
                children: "CHILDREN",
                title: ""
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
                //  点击左侧目录，初始化右侧内容
                if (treeNode.TYPE == 2) {
                    currentNode = treeNode;
                    initRightForSchema(treeNode);
                } else {
                    initRight();//初始化右侧目录信息
                }
            },
            beforeDrop: function (treeId, treeNodes, targetNode, moveType, isCopy) {
                //目录不允许拖到根节点
                var curNode = treeNodes[0];
                if (curNode) {
                    if (curNode.TYPE == 2) {
                        return !(targetNode == null || (moveType != "inner" && !targetNode.parentTId));
                        ;
                    }
                }
                return true;
            },
            onDrop: function (event, treeId, treeNodes, targetNode, moveType, isCopy) {
                var list = [], nodes = [];
                if (treeNodes && treeNodes.length == 1) {
                    var curNode = treeNodes[0];
                    if (curNode) {
                        var parentNode = curNode.getParentNode();
                        if (parentNode && parentNode["CHILDREN"]) { //  拖到非根节点
                            nodes = parentNode["CHILDREN"];
                        } else { //  拖到根节点
                            nodes = schemaTree_JC.getNodes();
                        }
                    }
                }
                if (nodes != null && nodes.length > 0) {
                    for (var i = 0; i < nodes.length; i++) {
                        var node = nodes[i];
                        var parent = node.getParentNode();
                        if (node) {
                            list.push({
                                id: node.ID || "",
                                pid: parent ? (parent.ID || "") : 0,
                                type: node.TYPE || 0
                            });
                            if (parent) {
                                node.PID = parent.ID;
                            } else {
                                node.PID = '';
                            }
                            //schemaTree_JC.updateNode(node);
                        }
                    }
                    if (list != null && list.length > 0) {
                        $.post(ctx + "/schema/schemaSort.action", {
                            "json": JSON.stringify(list)
                        }, function (json) {
                        }, "json");
                    }

                }
            }
        }
    };

    function initRightForSchema(treeNode) {
        //  初始化目录名称、编码、授权部门等信息
        $("#nameTd_JC").val("");
        $("#codeTd_JC").val("");
        $("#department").val("");
        //     $("#departments").val("");
        $(".ccl-multi-select-li").remove();
        $(".ccl-multi-select-active").removeClass("ccl-multi-select-active");
        $("#nameTd_JC").val(treeNode.NAME);
        $("#codeTd_JC").val(treeNode.CODE);


        //  获取目录信息
        $.post(ctx + "/schema/getTableInfo.action", {
            "id": treeNode.ID
        }, function (json) {
            if (json) {
                // 征集周期
                if (json.taskPeriod == 0) {         // 周
                    $("#rtaskPeriod_JC").val("周");
                } else if (json.taskPeriod == 1) {  // 月
                    $("#rtaskPeriod_JC").val("月");
                } else if (json.taskPeriod == 2) { // 季度
                    $("#rtaskPeriod_JC").val("季度");
                } else if (json.taskPeriod == 3) {
                    $("#rtaskPeriod_JC").val("半年");
                } else if (json.taskPeriod == 4) {	//	年
                    $("#rtaskPeriod_JC").val("年");
                } else if (json.taskPeriod == 5) {	//	天
                    $("#rtaskPeriod_JC").val("天");
                } else if (json.taskPeriod == 6) {	//  不限周期
                    $("#rtaskPeriod_JC").val("不限周期");
                } else {
                    $("#rtaskPeriod_JC").val("未知");
                }

                $("#rdays_JC").val(json.days + "天");// 任务有效期
                if (json.taskPeriod == 6) {
                    $("#rdays_JC").val("");//不限周期为空
                }

                $("#rtableDesc_JC").val(json.tableDesc);// 目录描述
            }
        }, "json");

        //  启用右侧操作按钮
        $("#addBtn_JC,#saveBtn_JC").removeAttr("disabled");
        //  获取指标列表
        tableId = treeNode.ID;
        tableCode = treeNode.CODE;
        sortNum = 0;	    //	排序序号
        sortList = [];	    //	排序列表
        initFieldList();
    }

    function addDiyDom(treeId, treeNode) {
        var spaceWidth = 5;
        var switchObj = $("#" + treeNode.tId + "_switch"),
            icoObj = $("#" + treeNode.tId + "_ico");
        switchObj.remove();
        icoObj.parent().before(switchObj);
        var spantxt = $("#" + treeNode.tId + "_span").html();
        if (spantxt.length > 10) {
            spantxt = spantxt.substring(0, 10) + "...";
            $("#" + treeNode.tId + "_span").html(spantxt);
        }
    }

    var fieldSetting = {
        data: {
            key: {
                name: "name"
            }
        },
        view: {
            selectedMulti: true,
            showTitle: true,
            addDiyDom: addDiyDomOfField
        },
        edit: {
            enable: true,
            showRenameBtn: false,
            showRemoveBtn: false,
            drag: {
                autoExpandTrigger: true,
                isMove: true,
                prev: function (treeId, nodes, targetNode) {
                    return true;
                },
                inner: function (treeId, nodes, targetNode) {
                    return false;
                },
                next: function (treeId, nodes, targetNode) {
                    return true;
                }
            }
        },
        callback: {
            onDrop: function (event, treeId, treeNodes, targetNode, moveType, isCopy) {
                var list = [], nodes = fieldTree_JC.getNodes();
                if (nodes != null && nodes.length > 0) {
                    for (var i = 0; i < nodes.length; i++) {
                        var node = nodes[i];
                        if (node && node.id) {
                            list.push({
                                id: node.id,
                            });
                        }
                    }
                    if (list != null && list.length > 0) {
                        $.post(ctx + "/schema/fieldSort.action", {
                            "json": JSON.stringify(list)
                        }, function (json) {
                        }, "json");
                    }
                }
            }
        }
    };

    function addDiyDomOfField(treeId, treeNode) {
        var spaceWidth = 5;
        var switchObj = $("#" + treeNode.tId + "_switch"),
            icoObj = $("#" + treeNode.tId + "_ico");
        switchObj.remove();
        icoObj.parent().before(switchObj);
        var spantxt = $("#" + treeNode.tId + "_span").html();
        if (spantxt.length > 15) {
            spantxt = spantxt.substring(0, 15) + "...";
            $("#" + treeNode.tId + "_span").html(spantxt);
        }
    }

    // 递归展开指定节点及其所有子节点
    var level = 0;

    function expandTreeNode(node) {
        level++;
        schemaTree_JC.expandNode(node, true);
        if (level >= 2) {// 默认展开指定节点的第一级
            level = 0;
            return;
        }
        var children = node.CHILDREN;
        if (children) {
            $.each(children, function (i, item) {
                expandTreeNode(item);
            });
        }
    }

    var classifySetting = {
        data: {
            key: {
                name: "NAME",
                children: "CHILDREN"
            }
        },
        view: {
            selectedMulti: false
        },
        callback: {
            onClick: function (e, treeId, treeNode) {
                var nodes = classifyTree.getSelectedNodes();
                if (nodes && nodes.length > 0) {
                    var node = nodes[0];
                    if (node) {
                        if ($("#tableDiv_JC").is(":visible")) {
                            $("#tableDiv_JC input[name='classifyNameText']").val(node.NAME);
                            $("#tableDiv_JC input[name='classifyId']").val(node.ID);
                        } else if ($("#classifyDiv_JC").is(":visible")) {
                            $("#classifyDiv_JC input[name='classifyNameText']").val(node.NAME);
                            $("#classifyDiv_JC input[name='pid']").val(node.ID);
                        }
                        hideTree();
                    }
                }
            }
        }
    };

    var schemaTree_JC = $.fn.zTree.init($("#schemaTree_JC"), schemaSetting, schemaNodes);
    var fieldTree_JC = $.fn.zTree.init($("#fieldTree_JC"), fieldSetting, fieldNodes);
    var classifyTree = $.fn.zTree.init($("#classifyTree"), classifySetting, classifyNodes);

    //  查询资源目录树
    $.post(ctx + "/schema/getSchemaList.action", function (json) {
        if (schemaTree_JC && json && json.length > 0) {
            schemaTree_JC.addNodes(null, json);

            // 展开所有一层节点的第一级节点
            allNodes = schemaTree_JC.transformToArray(schemaTree_JC.getNodes());
            if (!isNull(allNodes)) {
                $.each(allNodes, function (i, item) {
                    if (item.level == 0) {// 展开所有一层节点的第一级节点
                        level = 0;
                        expandTreeNode(item);
                    }
                });
            }
        }

    }, "json");

    //  查询公共指标树
    $.post(ctx + "/schema/getCommonFieldList.action", function (json) {
        if (fieldTree_JC && json && json.length > 0) {
            fieldTree_JC.addNodes(null, json);
        }
    }, "json");

    //  查询分类树
    function refreshClassifyTree(excludeId) {
        $.post(ctx + "/schema/getClassifyList.action", {
            excludeId: excludeId || ""
        }, function (json) {
            if (json && json.length > 0) {
                $.fn.zTree.destroy("classifyTree");
                classifyTree = $.fn.zTree.init($("#classifyTree"), classifySetting, json);

            }
        }, "json");
    }

    var oldSchemaText = "";
    var oldCommonFieldText = "";

    //  资源目录树查询
    $("#searchSchemaTree_JC").keyup(function () {
        $("#searchSchemaTreeMsg_JC").hide();
        var val = $.trim($("#searchSchemaTree_JC").val());
        var allNodes = schemaTree_JC.transformToArray(schemaTree_JC.getNodes());
        schemaTree_JC.showNodes(allNodes);
        if (val != "") {
            var nodes = schemaTree_JC.getNodesByParamFuzzy("NAME", val);

            if (nodes.length == 0) {
                $("#searchSchemaTreeMsg_JC").show();
            }

            for (var i = 0, len = nodes.length; i < len; i++) {
                var node = nodes[i];
                node["searchType"] = true;
                getParents(node);
            }

            for (var i = 0, len = allNodes.length; i < len; i++) {
                var node = allNodes[i];
                if (!node["searchType"]) {
                    schemaTree_JC.hideNode(node);
                } else {
                    node["searchType"] = false;
                }
            }

            schemaTree_JC.expandAll(true);
        } else if (oldSchemaText != "") {
            schemaTree_JC.expandAll(false);
            // 展开所有一层节点的第一级节点
            allNodes = schemaTree_JC.transformToArray(schemaTree_JC.getNodes());
            if (!isNull(allNodes)) {
                $.each(allNodes, function (i, item) {
                    if (item.level == 0) {// 展开所有一层节点的第一级节点
                        level = 0;
                        expandTreeNode(item);
                    }
                });
            }


        }
        oldSchemaText = val;
    });

    //  公共指标树查询
    $("#searchCommonFieldTree_JC").keyup(function () {
        $("#searchCommonFieldTreeMsg_JC").hide();
        var val = $.trim($("#searchCommonFieldTree_JC").val());
        var allNodes = fieldTree_JC.transformToArray(fieldTree_JC.getNodes());
        fieldTree_JC.showNodes(allNodes);
        if (val != "") {
            var nodes = fieldTree_JC.getNodesByParamFuzzy("name", val);

            if (nodes.length == 0) {
                $("#searchCommonFieldTreeMsg_JC").show();
            }

            for (var i = 0, len = nodes.length; i < len; i++) {
                var node = nodes[i];
                node["searchType"] = true;
                getParents(node);
            }

            for (var i = 0, len = allNodes.length; i < len; i++) {
                var node = allNodes[i];
                if (!node["searchType"]) {
                    fieldTree_JC.hideNode(node);
                } else {
                    node["searchType"] = false;
                }
            }
            fieldTree_JC.expandAll(true);
        } else if (oldCommonFieldText != "") {
            fieldTree_JC.expandAll(false);
        }
        oldCommonFieldText = val;
    });

    //  获取父节点
    function getParents(node) {
        var parent = node.getParentNode();
        if (parent && !parent["searchType"]) {
            parent["searchType"] = true;
            getParents(parent);
        }
    }


    //  初始化征集周期下拉框
    $.getJSON(ctx + "/system/dictionary/listValues.action", {
        "groupKey": "task_period"
    }, function (result) {
        var html = '';
        if (result.items) {
            for (var i = 0, len = result.items.length; i < len; i++) {
                var item = result.items[i];
                html += '<option value="' + item.id + '">' + item.text + '</option>';
            }
            $("#taskPeriod").append(html);
        }
        $("#taskPeriod").select2({
            placeholder: '请选择征集周期',
            language: 'zh-CN',
            minimumResultsForSearch: -1
        });
    });
    $("#taskPeriod").change(function () {
        periodChanged();
        tableValidator.form();
    });

    //  征集周期改变时改变上报天数校验规则
    function periodChanged() {
        var period = $("#taskPeriod").val();
        var days = $.trim($("#days").val());
        if (days) {
            days = parseInt(days, 10);
        }
        $("#days").removeAttr("disabled");
        $("#days").rules("remove", "required,digits,min,max");
        if (days <= 0) {
            $("#days").val(1);
        }
        if (period == 0) {	//	周
            if (days > 7) {
                $("#days").val(7);
            }
            $("#days").rules('add', {
                required: true,
                digits: true,
                min: 1,
                max: 7
            });
        } else if (period == 1) {	//	月
            if (days > 30) {
                $("#days").val(30);
            }
            $("#days").rules('add', {
                required: true,
                digits: true,
                min: 1,
                max: 30
            });
        } else if (period == 2) {	//	季度
            if (days > 90) {
                $("#days").val(90);
            }
            $("#days").rules('add', {
                required: true,
                digits: true,
                min: 1,
                max: 90
            });
        } else if (period == 3) {	//	半年
            if (days > 180) {
                $("#days").val(180);
            }
            $("#days").rules('add', {
                required: true,
                digits: true,
                min: 1,
                max: 180
            });
        } else if (period == 4) {	//	年
            if (days > 365) {
                $("#days").val(365);
            }
            $("#days").rules('add', {
                required: true,
                digits: true,
                min: 1,
                max: 365
            });
        } else if (period == 5) {	//	天
            $("#days").val(1);
            $("#days").rules('add', {
                required: true,
                digits: true,
                min: 1,
                max: 1
            });
        } else if (period == 6) {	//	实时
            $("#days").val("");
            $("#days").rules('add', {
                required: false,
                digits: false

            });
            tableValidator.element("#days");
            $("#days").attr("disabled", "disabled");
        }
    }

    //  初始化数据类别下拉框
    $.getJSON(ctx + "/system/dictionary/listValues.action", {
        "groupKey": "data_category"
    }, function (result) {
        var html = '';
        if (result.items) {
            for (var i = 0, len = result.items.length; i < len; i++) {
                var item = result.items[i];
                html += '<option value="' + item.id + '">' + item.text + '</option>';
            }
            $("#dataCategory").append(html);
        }
        $("#dataCategory").select2({
            placeholder: '请选择数据类别',
            language: 'zh-CN',
            minimumResultsForSearch: -1
        });
    });

    $("#personType").select2({
        placeholder: '请选择目录类别',
        language: 'zh-CN',
        minimumResultsForSearch: -1
    });

    //  数据分类校验
    var classifyValidator = $("#classifyForm_JC").validateForm({
        classifyName: {
            required: true,
            maxlength: 20,
            tableComment: []
        },
        classifyRemark: {
            maxlength: [400]
        }
    });

    //  数据目录校验
    var tableValidator = $("#tableForm_JC").validateForm({
        name: {
            required: true,
            rangelength: [2, 30],
            tableComment: []
        },
        code: {
            required: true,
            rangelength: [2, 25],//3.0.2 产品整改
            tableName: []
        },
        taskPeriod: {
            required: true
        },
        days: {
            required: true,
            digits: true
        },
        personType: {
            required: true
        },
        dataCategory: {
            required: true
        },
        tableDesc: {
            maxlength: 400
        }
    });

    // 公共指标校验
    var commonFieldValidator = $("#commonFieldForm").validateForm({
        name: {
            required: true,
            rangelength: [2, 30],
            tableComment: []
        },
        code: {
            required: true,
            rangelength: [2, 30],
            tableName: [],
            keyword: []
        },
        type: {
            required: true
        },
        len: {
            required: true,
            digits: true,
            max: 4011,
            min: 1
        }
        // ,
        // isNullable: {
        //     required: true
        // },
        // postil: {
        //     maxlength: 200
        // }
    });

    //	指标校验器
    var fieldValidator = $("#fieldForm_JC").validateForm({
        name: {
            required: true,
            rangelength: [2, 30],
            tableComment: []
        },
        code: {
            required: true,
            rangelength: [2, 30],
            tableName: [],
            keyword: []
        }
        // ,
        // requiredGroup: {
        //     digits: true,
        //     min: 1,
        //     max: 99
        // }
    }, ".innerSelect,.innerCheckbox");

    classifyValidator.form();
    tableValidator.form();
    commonFieldValidator.form();

    //  数据分类下拉框事件
    $("input[name='classifyNameText']").click(function () {
        if (!$("#treePanel").is(":visible")) {
            var $this = $(this);
            var offset = $this.offset();
            var left = offset.left + "px";
            var top = (offset.top + $this.outerHeight() + 5 - $(document).scrollTop()) + "px";
            var width = $this.outerWidth() + "px";
            $("#treePanel").css({left: left, top: top, width: width}).fadeIn("fast");
            $("body").bind("mousedown", onBodyDown);
        }
    });

    function hideTree() {
        $("#treePanel").fadeOut("fast");
        $("body").unbind("mousedown", onBodyDown);
    }

    function onBodyDown(event) {
        if (!(event.target.name == "classifyNameText" || event.target.id == "treePanel"
                || $(event.target).parents("#treePanel").length > 0)) {
            hideTree();
        }
    }

    //  保存数据分类（opType[1:add, 2:edit]）
    function saveClassify(index, opType) {
        if (classifyValidator.form()) {
            loading();
            $("#classifyForm_JC").ajaxSubmit({
                beforeSerialize: function () {
                    //$("#classifyCode").val($("#classifyCode").val().toUpperCase());
                },
                success: function (result) {
                    loadClose();
                    if (result.result) {
                        layer.close(index);
                        updateClassifyTree(result.message, opType);
                        $.alert("操作成功！", 1);
                    } else {
                        $.alert(result.message || "操作失败！", 2);
                    }
                },
                dataType: "json"
            });
        } else {
            $.alert("表单验证不通过！");
        }
    }

    //  更新数据分类树（opType[1:add, 2:edit]）
    function updateClassifyTree(id, opType) {
        var classifyName_JC = $("#classifyName_JC").val();
        var classifyRemark_JC = $("#classifyRemark_JC").val();
        var pid = $("input[name='pid']").val();
        //  获取父级数据分类
        var parentNodes = schemaTree_JC.getNodesByParam("ID", pid, null);
        var parentNode = null;
        if (parentNodes && parentNodes.length > 0) {
            parentNode = parentNodes[0];
        }

        //获取子节点
        var nodes;
        if (opType == 2) {
            var currentNode = schemaTree_JC.getNodesByParam("ID", id, null);
            nodes = currentNode[0].CHILDREN;
        }
        //  编辑时，删除旧数据分类
        if (opType == 2) {   //  edit
            parentNodes = schemaTree_JC.getNodesByParam("ID", id, null);
            if (parentNodes && parentNodes.length > 0) {
                var oldNode = parentNodes[0];
                schemaTree_JC.removeNode(oldNode);
            }
        }
        //  新父级数据分类下添加本次新增或修改的数据分类
        schemaTree_JC.addNodes(parentNode, -1, {
            "ID": id,
            "REMARK": classifyRemark_JC,
            "NAME": classifyName_JC,
            "PID": pid,
            "TYPE": 1,
            "icon": ctx + "/app/images/schema/folder.png"
        });
        if (opType == 2) {
            currentNode = schemaTree_JC.getNodesByParam("ID", id, null);
            schemaTree_JC.addNodes(currentNode[0], nodes);
        }
    }

    function formatNewNode(value) {
        var spaceWidth = 5;
        var spantxt = value;
        if (spantxt.length > 10) {
            spantxt = spantxt.substring(0, 10) + "...";
        }
        return spantxt
    }

    //  打开新增数据分类弹框
    $("#addClassifyBtn_JC").click(function () {
        refreshClassifyTree();
        $("#classifyForm_JC")[0].reset();
        $("#classifyForm_JC input[name='classifyNameText']").val("请选择父节点");
        $("input[name='pid']").val("");
        $("#classifyId").val("");
        $.openWin({
            title: "新增数据分类",
            content: $("#classifyDiv_JC"),
            area: ['600px', '410px'],
            yes: function (index) {
                saveClassify(index, 1);
            }
        });
        classifyValidator.form();
    });

    //  打开数据分类修改弹窗
    function openClassifyEditWin(node) {
        refreshClassifyTree(node.ID);
        $("#classifyForm_JC")[0].reset();
        $("#classifyForm_JC input[name='classifyNameText']").val("请选择父节点");
        $("#classifyId_JC_classify").val(node.ID);
        $("#classifyName_JC").val(node.NAME);
        $("#classifyRemark_JC").val(node.REMARK);
        $("#classifyForm_JC input[name='pid']").val(node.PID);
        var parentNodes = schemaTree_JC.getNodesByParam("ID", node.PID, null);
        if (parentNodes && parentNodes.length > 0) {
            var parentNode = parentNodes[0];
            $("#classifyForm_JC input[name='classifyNameText']").val(parentNode.NAME);
        }
        $.openWin({
            title: "修改数据分类",
            content: $("#classifyDiv_JC"),
            area: ['600px', '410px'],
            yes: function (index) {
                saveClassify(index, 2);
            }
        });
        classifyValidator.form();
    }

    //  保存数据目录（opType[1:add, 2:edit]）
    function saveTable(index, opType) {
        if ($("#tableForm_JC input[name='classifyNameText']").val() == "请选择父节点") {
            $.alert("请选择父节点！");
            return false;
        }

        if (tableValidator.form()) {
            loading();
            $("#code_JC").removeAttr("disabled");
            $("#tableForm_JC").ajaxSubmit({
                beforeSerialize: function () {
                    $("#code_JC").val($("#code_JC").val().toUpperCase());
                },
                success: function (result) {
                    loadClose();
                    if (result.result) {
                        layer.close(index);
                        updateTableTree(result.message, opType);
                        $.alert("操作成功！", 1);
                        initRightForSchema(currentNode);
                        $("#templateId").val("");
                    } else {
                        $.alert(result.message || "操作失败！", 2);
                    }
                },
                dataType: "json"
            });
        } else {
            $.alert("表单验证不通过！");
        }
    }

    //  更新数据目录树（opType[1:add, 2:edit]）
    function updateTableTree(id, opType) {
        var name = $("#name").val();
        var code = $("#code_JC").val();
        var pid = $("input[name='classifyId']").val();
        //  获取父级数据分类
        var parentNodes = schemaTree_JC.getNodesByParam("ID", pid, null);
        var parentNode = null;
        if (parentNodes && parentNodes.length > 0) {
            parentNode = parentNodes[0];
        }
        //  编辑时，删除旧数据分类
        if (opType == 2) {   //  edit
            parentNodes = schemaTree_JC.getNodesByParam("ID", id, null);
            if (parentNodes && parentNodes.length > 0) {
                var oldNode = parentNodes[0];
                schemaTree_JC.removeNode(oldNode);
            }
        }
        //  新父级数据分类下添加本次新增或修改的数据分类
        var newNode = {
            "ID": id,
            "CODE": code,
            "NAME": name,
            "PID": pid,
            "TYPE": 2,
            "icon": ctx + "/app/images/schema/table.png"
        }
        schemaTree_JC.addNodes(parentNode, -1, newNode);
        currentNode = newNode;
    }

    //  打开新增数据目录弹框
    $("#addTableBtn_JC").click(function () {
        var flag = false;
        var allNodes = schemaTree_JC.transformToArray(schemaTree_JC.getNodes());
        if (allNodes.length > 0) {
            if (!isNull(allNodes)) {
                $.each(allNodes, function (i, item) {
                    if (item.TYPE == 1) {// 展开所有一层节点的第一级节点
                        flag = true;
                    }
                });
            }
        }
        if (flag) {
            $("#selectTemp").show();
            refreshClassifyTree();
            $("#tableForm_JC")[0].reset();
            $("#tableForm_JC input[name='classifyNameText']").val("请选择父节点");
            $("#tableId").val("");
            $("#code_JC").removeAttr("disabled");
            $("#taskPeriod").trigger("change");
            $("#dataCategory").trigger("change");
            $("#personType").trigger("change");
            $("#name").attr("style", "width: 250px; float: left;");
            $("#temId").attr("style", "right: 132px;");

            $.openWin({
                title: "新增数据目录",
                content: $("#tableDiv_JC"),
                area: ['600px', '590px'],
                yes: function (index) {
                    saveTable(index, 1);

                }
            });
            tableValidator.form();
        } else {
            $.alert("请先添加数据分类！");
        }
    });

    //  打开数据分类修改弹窗
    function openTableEditWin(node) {
        $("#selectTemp").hide();//修改没有选择模板
        refreshClassifyTree();
        $("#tableForm_JC")[0].reset();
        $("#tableForm_JC input[name='classifyNameText']").val("请选择父节点");
        $("#tableId").val(node.ID);
        $("#name").val(node.NAME);
        $("#name").attr("style", "");
        $("#temId").attr("style", "");
        $("#code_JC").val(node.CODE);
        $("#tableForm_JC input[name='classifyId']").val(node.PID);
        var parentNodes = schemaTree_JC.getNodesByParam("ID", node.PID, null);
        if (parentNodes && parentNodes.length > 0) {
            var parentNode = parentNodes[0];
            $("#tableForm_JC input[name='classifyNameText']").val(parentNode.NAME);
        }
        $.post(ctx + "/schema/getTableInfo.action", {
            "id": node.ID
        }, function (json) {
            if (json) {
                $("#taskPeriod").val(json.taskPeriod).change();
                if(json.days ==0){
                    $("#days").val("");
                }else {
                    $("#days").val(json.days);
                }
                $("#dataCategory").val(json.dataCategory).change();
                $("#personType").val(json.personType).change();//分类
                $("#tableDesc").val(json.tableDesc);
                $.post(ctx + "/schema/getDataCount.action", {
                    "code": node.CODE,
                    "deptId": ""
                }, function (rs) {
                    if (rs && rs.result && rs.message > 0) {
                        $("#code_JC").attr("disabled", "disabled");
                    }
                    $.openWin({
                        title: "修改数据目录",
                        content: $("#tableDiv_JC"),
                        area: ['600px', '570px'],
                        yes: function (index) {
                            saveTable(index, 2);
                        }
                    });
                    tableValidator.form();
                }, "json");
            }
        }, "json");
        tableValidator.form();
    }

    //  修改数据分类或数据目录
    $("#editSchemaBtn_JC").click(function () {
        var nodes = schemaTree_JC.getSelectedNodes();
        if (nodes && nodes.length > 0) {
            var node = nodes[0];
            if (node) {
                if (node.TYPE == 1) {   //  数据分类
                    openClassifyEditWin(node);
                } else if (node.TYPE == 2) {    //  数据目录
                    openTableEditWin(node);
                }
            }
        } else {
            $.alert("请选择要修改的数据分类或数据目录！");
        }
    });

    //  删除数据分类或数据目录
    $("#delSchemaBtn_JC").click(function () {
        var allNodes = schemaTree_JC.transformToArray(schemaTree_JC.getNodes());
        if (allNodes.length > 0) {
            var nodes = schemaTree_JC.getSelectedNodes();
            if (nodes && nodes.length > 0) {
                var node = nodes[0];
                if (node) {
                    var tips = "确认删除此" + (node.TYPE == 1 ? "分类" : "目录") + "吗？";
                    layer.confirm(tips, {icon: 3}, function (index) {
                        loading();
                        $.post(ctx + "/schema/deleteSchema.action", {
                            "id": node.ID,
                            "type": node.TYPE
                        }, function (data) {
                            loadClose();
                            if (data.result) {
                                schemaTree_JC.removeNode(node);
                                initRight();
                                $.alert("操作成功！", 1);
                            } else {
                                $.alert(data.message || "", 2);
                            }
                        }, "json");
                    });
                }
            } else {
                $.alert("请选择要删除的数据分类或数据目录！");
            }
        } else {
            $.alert("请选择要删除的数据分类或数据目录！");
        }
    });

    //初始化目录信息
    function initRight() {
        table.clear().draw();
        $("#nameTd_JC").val("");
        $("#codeTd_JC").val("");
        $("#department").val("");
        $("#rtaskPeriod_JC").val("");
        $(".ccl-multi-select-li").remove();
        $(".ccl-multi-select-active").removeClass("ccl-multi-select-active");
        $("#rdays_JC").val("");// 任务有效期
        $("#rtableDesc_JC").val("");// 目录描述
        $("#addBtn_JC,#saveBtn_JC").attr("disabled", "disabled");
    }

    $("#expandClassifyBtn").click(function () {
        var nodes = schemaTree_JC.getSelectedNodes();
        if (nodes && nodes.length > 0) {
            var node = nodes[0];
            if (node && node.TYPE == 1) {
                schemaTree_JC.expandNode(node, true, true);
            } else {
                schemaTree_JC.expandAll(true);
            }
        } else {
            schemaTree_JC.expandAll(true);
        }
    });

    //  美化指标类型
    $("#commonFieldType").select2({
        placeholder: '请选择指标类型',
        language: 'zh-CN',
        minimumResultsForSearch: -1
    });

    //  指标类型改变时修改指标长度规则
    $("#commonFieldType").change(function () {
        $("#commonFieldLen").rules("remove", "required,digits,min,max");
        var val = $(this).val();
        if (val == "VARCHAR2") {
            $("#commonFieldLen").val("200");
            $("#commonFieldLen").removeAttr("disabled");
            $("#commonFieldLen").rules("add", {
                required: true,
                digits: true,
                max: 4003,
                min: 1
            });
            commonFieldValidator.form();
        } else if (val == "CLOB") {
            $("#commonFieldLen").val("");
            $("#commonFieldLen").prop("disabled", "disabled");
            $("#commonFieldLen").prev("i").removeClass("fa-warning fa-check");
            $("#commonFieldLen").parent().parent().removeClass("has-error");
        }
        else if (val == "NUMBER") {
            $("#commonFieldLen").val("");
            $("#commonFieldLen").prop("disabled", "disabled");
            $("#commonFieldLen").prev("i").removeClass("fa-warning fa-check");
            $("#commonFieldLen").parent().parent().removeClass("has-error");
        }
        else if (val == "DATE") {
            $("#commonFieldLen").val("");
            $("#commonFieldLen").prop("disabled", "disabled");
            $("#commonFieldLen").prev("i").removeClass("fa-warning fa-check");
            $("#commonFieldLen").parent().parent().removeClass("has-error");
        }
    });

    //  保存公共指标（opType[1:add, 2:edit]）
    function saveCommonField(index, opType) {
        if (commonFieldValidator.form()) {
            loading();
            $("#commonFieldForm").ajaxSubmit({
                beforeSerialize: function () {
                    $("#commonFieldCode").val($("#commonFieldCode").val().toUpperCase());
                },
                success: function (result) {
                    loadClose();
                    if (result.result) {
                        layer.close(index);
                        updateCommonFieldTree(result.message, opType);
                        $.alert("操作成功！", 1);
                    } else {
                        $.alert(result.message || "操作失败！", 2);
                    }
                },
                dataType: "json"
            });
        } else {
            $.alert("表单验证不通过！");
        }
    }

    //  更新公共指标树（opType[1:add, 2:edit]）
    function updateCommonFieldTree(id, opType) {
        if (opType == 1) {  //  add
            fieldTree_JC.addNodes(null, -1, {
                "id": id,
                "code": $("#commonFieldCode").val(),
                "name": $("#commonFieldName").val(),
                "columnType": $("#commonFieldType").val(),
                "len": $("#commonFieldLen").val(),
                "postil": $("#commonFieldPostil").val(),
                "icon": ctx + "/app/images/schema/field.png"
            });
        } else if (opType == 2) {   //  edit
            nodes = fieldTree_JC.getNodesByParam("id", id, null);
            if (nodes && nodes.length == 1) {
                var node = nodes[0];
                node["code"] = $("#commonFieldCode").val();
                node["name"] = $("#commonFieldName").val();
                node["columnType"] = $("#commonFieldType").val();
                node["len"] = $("#commonFieldLen").val();
                node["postil"] = $("#commonFieldPostil").val();
                fieldTree_JC.updateNode(node);
            }
        }
    }

    //  新增公共指标弹窗
    $("#addCommonFieldBtn_JC").click(function () {
        $("#commonFieldForm")[0].reset();
        $("#commonFieldId").val("");
        $("#commonFieldType").change();
        $.openWin({
            title: "新增公共指标",
            content: $("#commonFieldWin"),
            area: ['600px', '520px'],
            yes: function (index) {
                saveCommonField(index, 1);
            }
        });
        commonFieldValidator.form();
    });

    // 编辑公共指标弹窗
    $("#editCommonFieldBtn_JC").click(function () {
        var nodes = fieldTree_JC.getSelectedNodes();
        if (nodes && nodes.length > 0) {
            var node = nodes[0];
            if (node) {
                $("#commonFieldForm")[0].reset();
                $("#commonFieldId").val(node.id || "");
                $("#commonFieldName").val(node.name || "");
                $("#commonFieldCode").val(node.code || "");
                $("#commonFieldType").val(node.columnType).change();
                $("#commonFieldLen").val(node.len || "");
                $("#commonFieldPostil").val(node.postil || "");
                $.openWin({
                    title: "编辑公共指标",
                    content: $("#commonFieldWin"),
                    area: ['600px', '520px'],
                    yes: function (index) {
                        saveCommonField(index, 2);
                    }
                });
                commonFieldValidator.form();
            }
        } else {
            $.alert("请选择要修改的公共指标！");
        }
    });

    //  删除公共指标
    $("#delCommonFieldBtn_JC").click(function () {
        var nodes = fieldTree_JC.getSelectedNodes();
        if (nodes && nodes.length > 0) {

            var idsArr = [];
            for (var i = 0; i < nodes.length; i++) {
                idsArr.push(nodes[i].id);
            }

            var tips = "确定删除所选记录吗？";
            layer.confirm(tips, {icon: 3}, function (index) {
                loading();
                $.post(ctx + "/schema/deleteSchema.action", {
                    "id": idsArr.join(","),
                    "type": 3
                }, function (data) {
                    loadClose();
                    if (data.result) {
                        // 循环两次为了解决树删除不了的问题
                        for (var j = 0; j < nodes.length; j++) {
                            var node = nodes[j];
                            fieldTree_JC.removeNode(node);
                            var rows = table.data();
                            if (rows && rows.length > 0) {
                                for (var i = 0; i < rows.length; i++) {
                                    var row = rows[i];
                                    if (row.commonFieldId == node.id) {
                                        row.commonFieldId = "";
                                        $("#" + row.id + "_name").removeAttr("disabled");
                                        $("#" + row.id + "_code").removeAttr("disabled");
                                        $("#" + row.id + "_type").removeAttr("disabled").change();
                                    }
                                }
                            }
                        }
                        $.alert("操作成功！", 1);
                    } else {
                        $.alert(data.message || "", 2);
                    }
                }, "json");
            });
        } else {
            $.alert("请选择要删除的公共指标！");
        }
    });

    //  公共指标加入列表按钮事件
    $("#addToList_JC").click(function () {
        if (!$("#codeTd_JC").val()) {
            $.alert("请先选择资源目录下的数据目录！");
            return;
        }

        var nodes = fieldTree_JC.getSelectedNodes();
        if (nodes && nodes.length > 0) {
            for (var i = 0; i < nodes.length; i++) {
                var node = nodes[i];
                if (node) {
                    addRow(node);
                }
            }
        } else {
            $.alert("请选择要加入列表的公共指标！");
        }
    });

    // 查询部门列表
    $.getJSON(ctx + "/system/department/getDeptList.action", function (result) {

        // 初始化协同部门
        $("#department").cclSelect({
            data: result,
            change: function () {
            },
            beforeDel: function (k, v) {
                var flag = true;
                $.ajax({
                    type: "POST",
                    dataType: 'json',
                    url: ctx + '/schema/getDataCount.action',
                    data: {
                        "code": $("#codeTd_JC").val(),
                        "deptId": k
                    },
                    async: false,
                    success: function (rs) {
                        if (rs && rs.result && rs.message > 0) {
                            $.alert(rs.deptName + "在该目录中已有上报数据，不能移除！", 2);
                            flag = false;
                        } else {
                            flag = true;
                        }
                    }
                });
                return flag;
            }
        });
    });

    //创建一个Datatable
    var table = $('#dataTable_JC').DataTable({
        ordering: true,
        order: [[0, 'asc']],
        searching: false,
        autoWidth: false,
        lengthChange: false,
        pageLength: 10,
        serverSide: false,//如果是服务器方式，必须要设置为true
        processing: true,//设置为true,就会有表格加载时的提示
        paging: false,
        columns: [
            {
                "data": null, "render": function (data, type, full) {
                    var imgUrl = ctx + "/app/images/schema/dragImg.png";
                    var op = "<img src='" + imgUrl + "' style='cursor: all-scroll;'/>";
                    return op;
                }
            },
            {"data": "name", "render": fmtName},
            {"data": "code", "render": fmtCode},
            {"data": "type", "render": fmtType},
            {"data": "len", "render": fmtLength},
            {
                "data": "ID", "render": function (data, type, full) {
                    var add = full.add || "0";
                    var op = "<input type='hidden' class='rowsId' value='" + full.id + "'/><a href='javascript:;' onclick='sl.addRuleRow()'>新增</a>&nbsp;&nbsp;";
                    op += "<a href='javascript:;' onclick='sl.deleteRow(\"" + full.id + "\", " + add + ")'>删除</a>";
                    return op;
                }
            }
        ],
        initComplete: function () {
            var $btns = $("#fieldBtns_JC");
            $("#schemaDiv_JC div.ttop").append($btns);
            $btns.show();
        },
        drawCallback: function (settings) {
            var check_id_JC = $("#check_id_JC").val();
            if (!isNull(check_id_JC)) {
                // $("#" + check_id_JC).parents().find("tr").removeClass("active");
                $("#" + check_id_JC).parent().parent().parent().addClass("active");
            }

            //	隐藏排序图标、解绑表头排序功能
            var $th = $("#fieldForm_JC").find("th.sorting_desc,th.sorting,th.sorting_asc");
            $th.removeClass("sorting_desc sorting sorting_asc");
            $th.unbind("click");
            $th.css("outline", "none");
            $th.css("cursor", "auto");

            //	重置按钮状态
            var $tr = $("#dataTable_JC tbody tr[role='row']");
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
        }
    });

//点击“新增”即在该指标字段下行新增一条编辑字段
    function addRuleRow() {
        addRow();
    }

//	规则管理
    function openRuleWin(id, add) {
        $("#rowId_JC").val(id);
        $("#ruleDiv_JC input.rule").removeAttr("checked");
        var row = getRowById(id);
        var ruleIdList = row.ruleIdList || [];
        for (var i = 0; i < ruleIdList.length; i++) {
            var ruleId = ruleIdList[i];
            $("#" + ruleId).prop("checked", "checked");
        }
        $.openWin({
            title: "规则管理",
            content: $("#ruleDiv_JC"),
            yes: function (index) {
                layer.close(index);
                changeRule();
            }
        });
    }

//	改变字段规则
    function changeRule() {
        var $rules = $("#ruleDiv_JC input.rule");
        var rowId = $("#rowId_JC").val();
        var row = getRowById(rowId);
        if (row) {
            var ruleIdList = row.ruleIdList || [];
            var newRuleIdList = [];
            $.each($rules, function (i, obj) {
                var ruleId = $(obj).attr("id");
                if ($(obj).is(":checked")) {	//	选中的
                    newRuleIdList.push(ruleId);
                }
            });
            row.ruleIdList = newRuleIdList;
        }
    }

//	删除一行
    function deleteRow(id, add) {
        var rows = table.data();
        var i = 0;

        for (var j = 0; j < rows.length; j++) {
            if (id == rows[j].id) {
                i = j;
                break;
            }
        }

        if (rows.length > 1) {
            layer.confirm("确认删除该指标吗？", {
                icon: 3,
            }, function (index) {
                layer.close(index);
                var $tr = $("#" + id + "_name").parent("div").parent("td").parent("tr");
                var len = $tr.prevAll().length;
                var row = table.row(i);
                if (add != 1) {
                    delList.push(row.data());
                }
                row.remove().draw();
                deleteArray(len);
            });

        } else if (rows.length == 1) {
            $.alert('至少需要一个字段！');
        }
    }

    //	从列表中删除指定元素
    function deleteArray(index) {
        if (index >= 0 && index < sortList.length) {
            sortNum--;
            var oldVal = sortList[index];
            sortList.splice(index, 1);
            for (var i = 0; i < sortList.length; i++) {
                if (sortList[i] > oldVal) {
                    sortList[i] = sortList[i] - 1;
                }
                table.cell(sortList[i], 0).data(i);
            }
            table.draw();
        }
    }

    //  单击行显示焦点
    $('#dataTable_JC tbody').on('click', 'tr', function () {
        if (!$(this).hasClass('active')) {
            table.$('tr.active').removeClass('active');
            $(this).addClass('active');
        }
    });

    //	格式化指标名称
    function fmtName(data, type, full) {
        data = data || "";
        var dis = full.commonFieldId ? "disabled='true'" : "";
        return "<div class='input-icon right'><i class='fa'></i>"
            + "<input type='text' class='innerInput innerInputName form-control' value='"
            + data + "' id='" + full.id + "_name' name='name' " + dis + " /></div>";
    }

    //	格式化指标编码
    function fmtCode(data, type, full) {
        data = data || "";
        var dis = full.add == 1 ? "" : (dataCount > 0 ? "disabled='true'" : "");
        dis = full.commonFieldId ? "disabled='true'" : dis;
        return "<div class='input-icon right'><i class='fa'></i>"
            + "<input type='text' class='innerInput innerInputCode form-control' value='"
            + data + "' id='" + full.id + "_code' name='code' " + dis + " /></div>";
    }

    //	格式化指标类型
    function fmtType(data, type, full) {
        var value = full.type;
        var cls = full.add == 1 ? "add" : "";
        var eve = full.add == 1 ? "onchange='sl.typeChangeLen(\"" + full.id + "\")'" : "";
        var dis = full.add == 1 ? "" : "disabled='true'";
        dis = full.commonFieldId ? "disabled='true'" : dis;
        var op = "<select class='form-control innerSelect innerType " + cls + "' id='" + full.id + "_type' " + eve + " " + dis + ">"
            + "<option value='VARCHAR2' " + (value == "VARCHAR2" ? "selected='selected'" : "") + ">VARCHAR2</option>"
            + "<option value='DATE' " + (value == "DATE" ? "selected='selected'" : "") + ">DATE</option>"
            + "<option value='NUMBER' " + (value == "NUMBER" ? "selected='selected'" : "") + ">NUMBER</option>"
            + "<option value='CLOB' " + (value == "CLOB" ? "selected='selected'" : "") + ">CLOB</option>"
            + "</select>";
        return op;
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
        return "<input type='checkbox' class='innerCheckbox' "
            + "value='" + full.id + "'"
            + (data == 0 ? "checked='checked'" : "") + " id='" + full.id + "_nullable' />";
    }

    // //	格式化分组
    // function fmtGroup(data, type, full) {
    //     var isNullable = full.isNullable || 0;
    //     var dis = isNullable == 0 ? "" : "disabled='true'";
    //     data = data || "";
    //     return "<div class='input-icon right'><i class='fa'></i>"
    //         + "<input type='text' class='innerInput innerInputGroup form-control' value='"
    //         + data + "' id='" + full.id + "_requiredGroup' name='requiredGroup' " + dis + " /></div>";
    // }


    //	格式化指标状态
    function fmtStatus(data, type, full) {
        var value = full.status || "0";
        var op = "<select class='form-control innerSelect' id='" + full.id + "_status'>"
            + "    <option value='1' " + (value == "1" ? "selected='selected'" : "") + ">有效</option>"
            + "    <option value='0' " + (value == "0" ? "selected='selected'" : "") + ">无效</option>"
            + "</select>";
        return op;
    }

    //	根据下标移动表格行
    //	type==1，置顶
    //	type==2，上移
    //	type==3，下移
    //	type==4，置底
    function sortMove(index, type) {
        if (index >= 0 && index < sortList.length) {
            var curIndex = sortList[index];
            var anoIndex, i;
            switch (type) {
                case 1: //  第一个
                    for (i = 0; i < index; i++) {
                        sortList[index - i] = sortList[index - i - 1];
                        table.cell(sortList[index - i], 0).data(index - i);
                    }
                    sortList[0] = curIndex;
                    table.cell(curIndex, 0).data(0);
                    break;
                case 2: //  上一个
                    anoIndex = sortList[index - 1];
                    sortList[index - 1] = curIndex;
                    sortList[index] = anoIndex;
                    table.cell(curIndex, 0).data(index - 1);
                    table.cell(anoIndex, 0).data(index);
                    break;
                case 3: //  下一个
                    anoIndex = sortList[index + 1];
                    sortList[index + 1] = curIndex;
                    sortList[index] = anoIndex;
                    table.cell(curIndex, 0).data(index + 1);
                    table.cell(anoIndex, 0).data(index);
                    break;
                case 4: //  最后一个
                    for (i = index; i < sortList.length - 1; i++) {
                        sortList[i] = sortList[i + 1];
                        table.cell(sortList[i], 0).data(i);
                    }
                    sortList[sortList.length - 1] = curIndex;
                    table.cell(curIndex, 0).data(sortList.length - 1);
                    break;
            }
            table.draw();
        }
    }


    // //	勾选必填时，启用禁用分组输入框
    // function changeGroup(id) {
    //     var bool = $("#" + id + "_nullable").is(":checked");
    //     if (bool) {
    //         $("#" + id + "_requiredGroup").removeAttr("disabled");
    //     } else {
    //         $("#" + id + "_requiredGroup").val("");
    //         $("#" + id + "_requiredGroup").attr("disabled", "disabled");
    //     }
    // }

    //	初始化checkbox
    function initCheckbox($obj) {
        if (!$obj) {
            $obj = $("#dataTable_JC input.innerCheckbox");
        }
        $obj.iCheck({
            labelHover: false,
            checkboxClass: 'icheckbox_square-blue',
            radioClass: 'iradio_square-blue',
            increaseArea: '20%'
        });
        $(".icheckbox_square-blue").css("margin-right", "0px");
        $obj.on('ifChanged', function (event) {
            changeGroup($(this).val());
        });
    }

    function initFieldList() {
        $.post(ctx + "/schema/getDataCount.action", {
            code: tableCode
        }, function (json) {
            if (json && json.result) {
                try {
                    dataCount = parseInt(json.message, 10);
                } catch (e) {
                    dataCount = 0;
                }
                //	查询指标列表
                $.post(ctx + "/schema/getFieldList.action", {
                    id: tableId
                }, function (json) {
                    if (json && json.list) {
                        table.clear().draw();
                        sortNum = json.list.length || 0;
                        if (sortNum > 0) {
                            table.rows.add(json.list);
                            for (var i = 0; i < sortNum; i++) {
                                sortList.push(i);
                                table.cell(i, 0).data(i);
                            }
                            table.draw();
                            $(".innerType").trigger("change");
                            fieldValidator.form();
                            initCheckbox();
                        } else {
                            addRow();
                        }
                    }
                }, "json");
            }
        }, "json");
    }

    //	类型改变时修改长度默认值
    function typeChangeLen(id) {

        changeLenRule(id);
        var type = $("#" + id + "_type").val();
        if (type == "VARCHAR2") {
            $("#" + id + "_len").val(200);
            fieldValidator.element($("#" + id + "_len"));
        } else if (type == "CLOB") {
            $("#" + id + "_len").val("");

        }
        else if (type == "DATE") {
            $("#" + id + "_len").val("");
        }
        else if (type == "NUMBER") {
            $("#" + id + "_len").val("");
        }
    }

    //	 修改长度校验规则
    function changeLenRule(id) {
        var type = $("#" + id + "_type").val();

        $("#" + id + "_len").removeAttr("disabled");
        $("#" + id + "_len").rules("remove", "required,digits,min,max");


        if (type == "VARCHAR2") {
            $("#" + id + "_len").rules("add", {
                required: true,
                digits: true,
                max: 4022,
                min: 1
            });
        } else if (type == "CLOB") {
            $("#" + id + "_len").attr("disabled", "disabled");
            $("#" + id + "_len").prev("i").removeClass("fa-warning fa-check");

        } else if (type == "NUMBER") {
            $("#" + id + "_len").attr("disabled", "disabled");
            $("#" + id + "_len").prev("i").removeClass("fa-warning fa-check");
        } else if (type == "DATE") {
            $("#" + id + "_len").attr("disabled", "disabled");
            $("#" + id + "_len").prev("i").removeClass("fa-warning fa-check");
        }
    }

    //	添加一行
    function addRow(node) {
        // 重新绑定数据
        var flag = true;
        bindTableData(flag);
        var rows = table.data();
        var newRow = {"id": new Date().getTime()};
        newRow["logicTableId"] = tableId;
        newRow["name"] = node ? (node.name || "") : "";
        newRow["code"] = node ? (node.code || "") : "";
        newRow["type"] = node ? (node.columnType || "VARCHAR2") : "";

        newRow["len"] = node ? (node.len) : "200";

        newRow["commonFieldId"] = node ? (node.id || "") : "";
        newRow["status"] = "1";

        newRow["fieldSort"] = sortNum++;
        newRow["add"] = 1;	//	新增的标识

        table.row.add(newRow).draw();
        addSomeRule(newRow.id);
        sortList.push(sortList.length);
        return true;
    }

    //	新增时name、code、len等增加校验规则      ******这里占用了很长的时间,大概三到四秒********
    function addSomeRule(id) {
        initCheckbox($("#" + id + "_nullable"));

        changeLenRule(id);
        fieldValidator.form();
    }

    $("#addBtn_JC").click(function () {
        addRow();
    });


    //	根据ID获取一行数据
    function getRowById(id) {
        var rows = table.data();
        for (var i = 0; i < rows.length; i++) {
            var row = rows[i];
            if (row.id == id) {
                return row;
            }
        }
    }

    //	从列表中删除指定元素
    function deleteArray(index) {
        if (index >= 0 && index < sortList.length) {
            sortNum--;
            var oldVal = sortList[index];
            sortList.splice(index, 1);
            for (var i = 0; i < sortList.length; i++) {
                if (sortList[i] > oldVal) {
                    sortList[i] = sortList[i] - 1;
                }
                table.cell(sortList[i], 0).data(i);
            }
            table.draw();
        }
    }


    //	改变指标规则
    function changeRule() {
        var $rules = $("#ruleDiv_JC input.rule");
        var rowId = $("#rowId_JC").val();
        var row = getRowById(rowId);
        if (row) {
            var ruleIdList = row.ruleIdList || [];
            var newRuleIdList = [];
            $.each($rules, function (i, obj) {
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
        for (var i = 0, len = list.length; i < len; i++) {
            var row = list[i];
            var code = $("#" + row.id + "_code").val();
            code = code.toUpperCase();
            if (!map[code]) {
                map[code] = true;
            } else {
                $("#" + row.id + "_code").trigger("click");
                $.alert("指标编码[" + code + "]重复！", 0, function () {
                    $("#" + row.id + "_code").focus();
                });
                return false;
            }
        }
        return true;
    }

    //	整数要提交的数据
    function disposalData() {
        var rows = table.data();
        //  获取拖动之后表格当前的顺序
        var sortIdMap = {};
        var $inputs = $("#dataTable_JC tr .rowsId");
        $inputs.each(function (i) {
            sortIdMap[$(this).val()] = i;
        })

        for (var i = 0; i < sortList.length; i++) {
            var row = rows[sortList[i]] || {};
            var id = row.id;
            var add = row.add;	//	1:新增
            var copy = {};
            copy = {"add": add || 0};
            copy["commonFieldId"] = row.commonFieldId;
            copy["logicTableId"] = tableId;
            copy["name"] = $.trim($("#" + id + "_name").val());
            copy["code"] = $.trim($("#" + id + "_code").val()).toUpperCase();
            copy["type"] = $.trim($("#" + id + "_type").val());
            copy["len"] = $.trim($("#" + id + "_len").val()) || 0; // 为标识字段到后台转成空，
            copy["status"] = "1";

            copy["fieldSort"] = sortIdMap[id];

            var str = JSON.stringify(row.ruleIdList || []);
            copy["ruleIdListJson"] = str || "";

            if (add == 1) {	//	新增的指标
                addList.push(copy);
            } else {
                copy["id"] = id;
                modList.push(copy);
                if (row.name != copy.name) {	//	指标名称被修改的指标(修改表注释)
                    nameList.push(copy);
                }
                if (row.code != copy.code) {	//	指标编码被修改的指标(修改表名)
                    copy["oldCode"] = row.code;
                    codeList.push(copy);
                }
            }
        }
    }

    //	保存数据
    function saveFieldList() {
        $("#deptId").val($("#department").val())
        if (fieldValidator.form()) {
            if (!checkSameCode()) {
                return;
            }
            loading();
            disposalData();
            //	提交数据
            $.post(ctx + "/schema/saveFieldList.action", {
                "id": tableId,
                "deptId": $("#deptId").val(),
                "addList": JSON.stringify(addList),
                "modList": JSON.stringify(modList),
                "delList": JSON.stringify(delList),
                "nameList": JSON.stringify(nameList),
                "codeList": JSON.stringify(codeList)
            }, function (data) {
                loadClose();
                if (data.result) {
                    $.alert('保存成功！', 1, function () {
                        initRightForSchema(currentNode);
                        delList = [];
                        modList = [];
                        addList = [];
                        nameList = [];
                        codeList = [];
                    });
                } else {
                    $.alert(data.message || "保存失败！", 2);
                }
            }, "json");
        } else {
            $.alert('表单验证不通过！');
        }

    }

    $("#saveBtn_JC").click(function () {
        addList = [];
        modList = [];
        nameList = [];
        codeList = [];
        saveFieldList();
    });

    // 选择模板
    function selectTemplate() {
        initSelectTemplate();
        $.openWin({
            title: '选择目录模板',
            content: $("#winSelectTemplate"),
            btnAlign: 'c',
            area: ['50%', '90%'],
            btn: ['确定', '取消'], //按钮
            yes: function (index, layero) {
                addSelectTemplate(index);

            }
        });

        // 初始化IE9 placeholder
        $(".phTips").remove();
        jQuery('input[placeholder]').placeholder();
        $("#searchSchemaTree_JC").next().css("marginLeft", '10px');
        $("#searchSchemaTree_JC").next().css("marginTop", '-35px');
        $("#searchSchemaTree_JC").next().css("line-height", '34px');
        $("#searchCommonFieldTree_JC").next().css("marginLeft", '10px');
        $("#searchCommonFieldTree_JC").next().css("marginTop", '-35px');
        $("#searchCommonFieldTree_JC").next().css("line-height", '34px');
    }

    var selectTemplateTable;

    // 初始选择窗口
    function initSelectTemplate() {
        selectTemplateReset();//重置
        if (!selectTemplateTable) {
            selectTemplateTable = $('#templateGrid').DataTable(// 创建一个Datatable
                {
                    ajax: {
                        url: CONTEXT_PATH + "/schema/templateList.action",
                        type: 'post',
                        data: {
                            selectLogicName: $.trim($('#selectLogicName').val()),
                            selectLogicCode: $.trim($('#selectLogicCode').val())
                        }
                    },
                    serverSide: true,// 如果是服务器方式，必须要设置为true
                    processing: false,// 设置为true,就会有表格加载时的提示
                    lengthChange: true,// 是否允许用户改变表格每页显示的记录数
                    searching: false,// 是否允许Datatables开启本地搜索
                    paging: true,
                    pageLength: 10,
                    ordering: false,
                    autoWidth: false,
                    columns: [{
                        "className": 'details-control',
                        "orderable": false,
                        "data": null,
                        "defaultContent": '<div class="icon">&nbsp;</div>'

                    }, {
                        "data": "name"
                    }, {
                        "data": "code"
                    }],
                    initComplete: function (settings, data) {
                        $('#templateGrid tbody').on('click', 'tr', function () {
                            if ($(this).hasClass('active')) {
                                $(this).removeClass('active');
                            } else {
                                selectTemplateTable.$('tr.active').removeClass('active');
                                $(this).addClass('active');
                            }
                        });

                        // 行明细点击事件
                        $('#templateGrid tbody').on('click', 'td.details-control', function () {
                            var tr = $(this).closest('tr');
                            var row = selectTemplateTable.row(tr);
                            if (row.child.isShown()) { // This row is already open - close it
                                row.child.hide();
                                tr.removeClass('shown');
                            } else { // Open this row
                                row.child(showDetail(row.data())).show();
                                tr.addClass('shown');
                            }
                        });

                    }
                });
        } else {
            $("#selectTemlateSearch").trigger("click");
        }

    }

    // 模板查询 查询按钮初始化
    $("#selectTemlateSearch").click(function () {
        if (selectTemplateTable) {
            var data = selectTemplateTable.settings()[0].ajax.data;
            if (!data) {
                data = {};
                selectTemplateTable.settings()[0].ajax["data"] = data;
            }

            data["selectLogicName"] = $.trim($('#selectLogicName').val());
            data["selectLogicCode"] = $.trim($('#selectLogicCode').val());
            selectTemplateTable.ajax.reload();
        }
    });

    // 模板查询 重置按钮初始化
    $("#selectTemplateReset").click(function () {
        selectTemplateReset();
    });

    // 模板查询 重置按钮初始化
    function selectTemplateReset() {
        resetSearchConditions('#selectLogicName,#selectLogicCode');
    }

    // 显示行明细
    function showDetail(rowData) {
        var _html = '';
        $.ajax({
            type: "POST",
            dataType: 'json',
            url: ctx + '/schema/templateColumn.action',
            data: {
                id: rowData.id
            },
            async: false,
            success: function (result) {

                _html = '<table class="table table-bordered"  style="width:90%"><thead>' +
                    '<tr><th width=\"20%\">指标名称</th><th width=\"20%\">指标编码</th><th width=\"20%\">指标类型</th><th width=\"10%\">指标长度</th></tr>' +
                    '</thead>';
                _html += '<tbody>';
                $.each(result, function (i, item) {
                    _html += '<tr>';
                    _html += '<td>' + item.name + '</td>';
                    _html += '<td>' + item.code + '</td>';
                    _html += '<td>' + item.type + '</td>';
                    _html += '<td>' + item.len + '</td>';
                    _html += '</tr>';
                });
                _html += '</tbody></table>';
            }
        });
        return _html;
    }


    // 选择模板
    function addSelectTemplate(index) {
        var gridNodes = selectTemplateTable.rows('.active').data();
        if (gridNodes.length > 0) {
            var node = gridNodes[0];
            $.post(ctx + '/schema/getTemplateTableInfo.action', {
                id: node.id
            }, function (data) {
                loadClose();
                $("#templateId").val(data.id);
                $("#name").val(data.name);
                $("#code_JC").val(data.code);
                $("#taskPeriod").val(data.taskPeriod).change();
                $("#days").val(data.days);
                $("#dataCategory").val(data.dataCategory).change();
                $("#personType").val(data.personType).change();//目录类型
                $("#tableDesc").val(data.tableDesc);
                $.alert('模板选择成功!');
                parent.layer.close(index);// 关闭弹窗
            }, "json");

        } else {
            $.alert('请先选择模板!');
        }
    }

    $(function () {
        $('#dataTable_JC').sortable({
            containerSelector: 'table',
            itemPath: '> tbody',
            itemSelector: 'tr',
            placeholder: '<tr class="placeholder"/>',
            onDrop: function ($item, container, _super, event) {
                $item.removeClass(container.group.options.draggedClass).removeAttr("style");
                $("body").removeClass(container.group.options.bodyClass);
                $item.parent().find("tr").removeClass("active");
                var id_name = $item.find("input[name='name']").attr("id");
                $("#check_id_JC").val(id_name);
                $item.addClass("active");
                var flag = false;
                bindTableData(flag);
                //  单击行显示焦点
                $('#dataTable_JC tbody').on('click', 'tr', function () {
                    $(this).parent().find("tr").removeClass("active");
                    $(this).addClass('active');
                });
            }
        })
    });

    //tab切换，改变页面标题
    $(document).ready(function () {
        var i = 1;
        $(".tabbable-custom li a").each(function () {
            $(this).click(function () {
                //解决ie9placeholder位置错位问题
                //$("#searchSchemaTree_JC").next();
                $("#searchSchemaTree_JC").next().css("marginLeft", '10px');
                $("#searchSchemaTree_JC").next().css("marginTop", '-35px');
                $("#searchSchemaTree_JC").next().css("line-height", '34px');
                $("#searchCommonFieldTree_JC").next().css("marginLeft", '10px');
                $("#searchCommonFieldTree_JC").next().css("marginTop", '-35px');
                $("#searchCommonFieldTree_JC").next().css("line-height", '34px');


            });
            i++;
        });
    });

    //  重新绑定表格数据，渲染表格(解决拖动后再新增导致列错位，以及新填写的数据丢失的问题)
    function bindTableData(flag) {
        //   获取拖动之后表格当前的顺序
        var sortIdArr = [];
        var $inputs = $("#dataTable_JC tr .rowsId");
        $inputs.each(function (i) {
            sortIdArr[i] = $(this).val();
        });

        var rows = table.data();

        var newRows = [];
        table.clear();

        // 行拖动后，新增的行长度框 样式保持，需要将长度框重新禁用的行id
        var needDisabledIds = [];

        for (var j = 0; j < sortIdArr.length; j++) {
            var sortId = sortIdArr[j];
            for (var i = 0; i < rows.length; i++) {
                var row = rows[i];
                var id = row.id;
                if (sortId == row.id) {
                    row["name"] = $.trim($("#" + id + "_name").val());
                    row["code"] = $.trim($("#" + id + "_code").val()).toUpperCase();
                    row["type"] = $.trim($("#" + id + "_type").val());

                    if ("VARCHAR2" == $.trim($("#" + id + "_type").val())) {
                        row["len"] = $.trim($("#" + id + "_len").val()) || "200";
                    } else {
                        row["len"] = $.trim($("#" + id + "_len").val()) || 0;

                        // 添加需要禁用长度样式的行id
                        if(row["type"] == "DATE" || row["type"] == "NUMBER" || row["type"] == "CLOB"){
                            needDisabledIds.push(id);
                        }
                    }
                    var str = JSON.stringify(row.ruleIdList || []);
                    row["ruleIdListJson"] = str || "";
                    newRows.push(row);
                }
            }
        }

        table.clear();

        table.rows.add(newRows).draw();

        //行拖动后，新增的行长度框 样式保持修改，表格重绘后，添加长度框禁用样式
        $.each(needDisabledIds, function (i, id) {
            $("#" + id + "_len").attr("disabled", "disabled");
            $("#" + id + "_len").prev("i").removeClass("fa-warning fa-check");
        });

        if (flag == true) {
            for (var i = 0; i < newRows.length; i++) {
                addSomeRule(newRows[i].id);
            }
        }
    }


    //	刷新列表
    function refreshTable(tableId) {
        if (table) {
            var data = table.settings()[0].ajax.data;

            if (!data) {
                data = {};
                table.settings()[0].ajax["data"] = data;
            }

            data["id"] = tableId;
            table.ajax.reload();
        }
    }

    // 跳转到归集目录管理
    $("#gj").click(function () {
        var url = CONTEXT_PATH + '/schema/allocationList.action';
        $("#allocation_list").load(url);
    });


    return {
        deleteRow: deleteRow,
        openRuleWin: openRuleWin,
        addRuleRow: addRuleRow,
        addSelectTemplate: addSelectTemplate,
        selectTemplate: selectTemplate,
        typeChangeLen: typeChangeLen,
        selectRule: selectRule
    }

})();






