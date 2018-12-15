(function () {


    var versionId;
    $.getJSON(ctx + "/system/department/getDeptList.action", function (result) {
        // 初始下拉框
        $("#conditionDeptId").select2({
            placeholder: '',
            language: 'zh-CN',
            data: result
        });
        resizeSelect2($("#conditionDeptId"));
    });


    $.getJSON(ctx + "/schema/grant/getAllGranVersion.action", function (result) {
        // 初始下拉框
        $("#conditionversionId").select2({
            placeholder: '',
            language: 'zh-CN',
            data: result
        });

        if (versionId == null) {
            versionId = result[0].id;
        }

        $('#conditionversionId').val(result[0].id).trigger("change");
        // 初始化查询条件中select2的对齐为题
        $('.select2-hidden-accessible.form-search').next('span').css('margin-bottom', '5px');

        resizeSelect2($("#conditionversionId"));

        $('#conditionversionId').on('change', function () {
            versionId = $('#conditionversionId').val();
        });
    });

    var deptId;
    var verId;
    var nodeTree = [];// 存放当前选择部门中已有的目录节点和新拖拽进来的目录节点，传递到后台保存使用
    var leftToRightNodes = new Map(); // 记录从左侧拖到右侧树中的节点信息， 为了右侧树中删除节点时，左侧树恢复节点显示
    var leftToRightParentNodes = new Map();// 记录从左侧拖到右侧树中的节点的父节点信息， 为了右侧树中删除节点时，左侧树恢复节点显示

    // 部门下拉框值改变事件
    $("#conditionDeptId").bind("change", function () {
        nodeTree = [];
        deptId = $("#conditionDeptId").val();
        verId = $("#conditionversionId").val();
        if (deptId != 0) {
            $.post(ctx + "/schema/grant/schematreeByDepId.action", {
                depId: deptId,
                verId: verId
            }, function (data) {
                // 初始化右侧部门目录树
                $.fn.zTree.init($("#menuTree2"), setting2, data);
                initLeftTree(null, verId);
            }, "json");
        } else {
            initLeftTree(null, verId);
            $.fn.zTree.init($("#menuTree2"), setting2, null);
        }
    });
    // 版本号下拉框值改变事件
    $("#conditionversionId").bind("change", function () {
        nodeTree = [];
        deptId = $("#conditionDeptId").val();
        verId = $("#conditionversionId").val();

        if (deptId != 0) {
            $.post(ctx + "/schema/grant/schematreeByDepId.action", {
                depId: deptId,
                verId: verId
            }, function (data) {
                // 初始化右侧部门目录树
                $.fn.zTree.init($("#menuTree2"), setting2, data);
                initLeftTree(null, verId);
            }, "json");
        } else {
            initLeftTree(null, verId);
            $.fn.zTree.init($("#menuTree2"), setting2, null);
        }
    });

    var setting = {
        edit: {
            enable: true,
            showRenameBtn: false,
            showRemoveBtn: false,
            drag: {
                isCopy: false,
                isMove: true,
                prev: false,
                inner: false,
                next: false
            }
        },
        data: {
            keep: {
                leaf: true,
                parent: true
            },
            key: {
                name: "SCHEMANAME",
                children: "CHILDREN"
            }
        },
        callback: {
            beforeDrag: beforeDrag,
            beforeDrop: function (treeId, treeNodes, targetNode, moveType) {
                $.each(treeNodes, function (j, leftNode) {
                    leftNode.index = zTreeObj.getNodeIndex(leftNode);
                    leftToRightNodes.put(leftNode.ID, leftNode);
                    leftToRightParentNodes.put(leftNode.ID, leftNode.getParentNode());
                });
                return true;
            }
        }
    };

    var setting2 = {
        edit: {
            enable: true,
            showRenameBtn: false,
            showRemoveBtn: true,
            removeTitle: "移除目录"
        },
        data: {
            keep: {
                leaf: true,
                parent: true
            },
            key: {
                name: "SCHEMANAME",
                children: "CHILDREN"
            }
        },
        callback: {
            beforeRemove: function (treeId, treeNode) {
                loading();
                // check是否允许移除目录,同步校验
                var passFlag = true;
                $.ajax({
                    type: "POST",
                    dataType: 'json',
                    url: ctx + "/schema/getDataCount.action",
                    data: {
                        code: treeNode.CODE,
                        deptId: deptId,
                        versionId:versionId
                    },
                    async: false,
                    success: function (result) {
                        if (result.message > 0) {
                            passFlag = false;
                            $.alert($("#conditionDeptId option:selected").html() + '在该目录中已有上报数据，不能移除！');
                        }
                        loadClose();
                    }
                });
                return passFlag;
            },
            onRemove: function (event, treeId, treeNode) {// 节点移除事件回调
                $.each(nodeTree, function (i, item) {
                    if (!isNull(treeNode) && !isNull(item) && treeNode.ID == item.ID) {
                        nodeTree.splice(i, 1);
                        // 左侧树中显示删除的节点
                        var leftNode = leftToRightNodes.get(item.ID);
                        if (leftNode) {
                            initLeftTree(null, versionId);

                            zTreeObj.addNodes(leftToRightParentNodes.get(item.ID), leftNode.index, leftNode);
                            leftToRightNodes.remove(item.ID);
                            leftToRightParentNodes.remove(item.ID);
                        }
                    }
                });


            },
            onNodeCreated: function (event, treeId, treeNode) {// 节点创建事件回调
                nodeTree.push(treeNode);
            },
            onClick: function (event, treeId, treeNode) { // 单击查看目录字段
                initSchemaDetailTable(treeNode.ID);
            }
        }
    };

    // 初始化左侧树
    function initLeftTree(schemId, verId) {
        $.post(ctx + "/schema/grant/schematree.action", {
            //schemId: schemId,
            verId: verId,
            status:"1"
        }, function (data) {
            if (data && data.length > 0) {

                zTreeObj = $.fn.zTree.init($("#menuTree"), setting, data);
                allNodes = zTreeObj.transformToArray(zTreeObj.getNodes());

                if (!isNull(allNodes)) {
                    $.each(allNodes, function (i, item) {
                        if (item.level == 0) {// 展开所有一层节点的第一级节点
                            level = 0;
                            expandTreeNode(item);
                        }
                    });
                }

                // 隐藏左侧树中部门已有的目录
                var allSecondNodes = zTreeObj.getNodesByParam("TYPE", 2);
                $.each(nodeTree, function (i, item) {
                    $.each(allSecondNodes, function (j, leftNode) {
                        if (!isNull(leftNode) && !isNull(item) && leftNode.ID == item.ID) {
                            leftNode.index = zTreeObj.getNodeIndex(leftNode);
                            leftToRightNodes.put(leftNode.ID, leftNode);
                            leftToRightParentNodes.put(leftNode.ID, leftNode.getParentNode());
                            zTreeObj.removeNode(leftNode);
                        }
                    });
                });

                // 当切换部门时，保持搜索条件显示树
                conditionSearch();
            }
        }, 'json');
    }

    initLeftTree(null, versionId);

    function beforeDrag(treeId, treeNodes) {
        for (var i = 0, l = treeNodes.length; i < l; i++) {
            if (treeNodes[i].drag === false) {
                return false;
            } else if (treeNodes[i].parentTId && treeNodes[i].getParentNode().childDrag === false) {
                return false;
            }

        }

        if (isNull(deptId) || deptId == '0') {
            $.alert('请先选择部门！');
            return false;
        }


        return true;
    }

    // 递归展开指定节点及其所有子节点
    var level = 0;

    function expandTreeNode(node) {
        level++;
        zTreeObj.expandNode(node, true);

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

    var zTreeObj;
    var allNodes = [];
    var oldText = "";

    $("#mlmc").on('keyup', conditionSearch);

    function conditionSearch() {
        $("#searchTreeMsg").hide();
        var val = $.trim($("#mlmc").val());
        zTreeObj.showNodes(allNodes);
        if (val != "") {
            var nodes = zTreeObj.getNodesByParamFuzzy("SCHEMANAME", val);
            if (nodes.length == 0) {
                $("#searchTreeMsg").show();
            }
            for (var i = 0, len = nodes.length; i < len; i++) {
                var node = nodes[i];
                node["searchType"] = true;
                getParents(node);
            }
            for (var i = 0, len = allNodes.length; i < len; i++) {
                var node = allNodes[i];
                if (!node["searchType"]) {
                    zTreeObj.hideNode(node);
                } else {
                    node["searchType"] = false;
                }
            }
            zTreeObj.expandAll(true);
        } else if (oldText != "") {
            zTreeObj.expandAll(false);
            if (!isNull(allNodes)) {
                $.each(allNodes, function (i, item) {
                    if (item.level == 0) {// 展开所有一层节点的第一级节点
                        level = 0;
                        expandTreeNode(item);
                    }
                });
            }
        }
        oldText = val;
    }

    function getParents(node) {
        var parent = node.getParentNode();
        if (parent && !parent["searchType"]) {
            parent["searchType"] = true;
            getParents(parent);
        }
    }

    $("#saveSchemaGrant").click(function () {
        // if (nodeTree.length == 0) {
        // $.alert("请先给部门添加资源目录！");
        // return;
        // }
        $("#saveSchemaGrant").prop('disable', true);

        var ids = [];
        var verConId = [];
        $.each(nodeTree, function (i, item) {
            ids.push(item.ID);
            verConId.push(item.TABLE_VERSION_CONFIG_ID);

        });
        $.post(ctx + "/schema/grant/saveSchemaGrant.action", {
            resIds: ids,
            deptId: deptId,
            versionId: verId,
            versionConfigIds: verConId
        }, function (data) {
            $("#saveSchemaGrant").prop('disable', false);

            if (!data.result) {
                $.alert('保存失败!', 2);
            } else {
                $.alert('保存成功!', 1, function () {// 保存成功，刷新ztree
                    var zTree = $.fn.zTree.getZTreeObj("menuTree2");
                    zTree.reAsyncChildNodes(null, "refresh");
                });
            }
        }, "json");

    });

    /*----------------------------目录详情----------------------------------*/

    // 目录详情弹框
    function initSchemaDetailTable(id) {
        $.getJSON(ctx + '/schema/grant/getDetail.action', {
            id: id,
            versionId: $('#conditionversionId').val()
        }, function (result) {
            var schema = result.schema;
            $('#nameTd').val(schema.name);
            $('#codeTd').val(schema.code);
            $('#rtaskPeriod').val(schema.taskPeriodVo);
            if (!isNull(schema.days)) {
                $('#rdays').val(schema.days + '天');
            }
            $('#rtableDesc').val(schema.tableDesc);

            $("#dataCategory").val(schema.dataCategoryVo);
            var table = $('#schemaTable').DataTable({
                dom: '<t>r<"tfoot"lp>',
                destroy: true,// 如果需要重新加载的时候请加上这个
                lengthChange: false,// 是否允许用户改变表格每页显示的记录数
                searching: false,// 是否允许Datatables开启本地搜索
                ordering: false,
                autoWidth: false,
                paging: false,
                pageLength: 5,
                data: result.data,
                // 使用对象数组，一定要配置columns，告诉 DataTables 每列对应的属性
                // data 这里是固定不变的
                columns: [{
                    "data": "name"
                }, {
                    "data": "code"
                }, {
                    "data": "type"
                }, {
                    "data": "len"
                }, {
                    "data": "isNullable",
                    "render": stateFormatter
                }, {
                    "data": "requiredGroup"
                }, {
                    "data": "postil"
                }]
            });
            $.openWin({
                title: '目录详情',
                content: $("#schemaDiv"),
                area: ['900px', '550px'],
                btn: ["关闭"],
                btnAlign: 'r'
            });
        });
    }


    // 格式化必填显示
    function stateFormatter(data, type, full) {
        if (data === 0) {
            return "是";
        } else {
            return "否";
        }
    }

})();
