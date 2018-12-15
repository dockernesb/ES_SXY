var templeteConfig = (function () {
    // 记录当前选中的资源信息，key：themeId，value:树对应的资源节点node对象
    var checkedThemesMap = new Map();
    // 记录当前选中的资源字段信息，key：themeId，value:是以字段名columnName为key，以字段列表行数据为value的map
    var checkedThemeColumnsMap = new Map();
    var nEditing = null;// 字段列表编辑中的行

    var rules = {
        creditName: {
            required: true,
            unblank: [],
            illegalCharacter: ['-（）'],
            maxlength: 50
        },
        reportTitle: {
            required: true,
            unblank: [],
            illegalCharacter: ['-（）'],
            maxlength: 50
        },
        address: {
            required: true,
            unblank: [],
            illegalCharacter: ['：，。（）'],
            maxlength: 500
        },
        reportSource: {
            required: true,
            unblank: [],
            illegalCharacter: ['-（）'],
            maxlength: 125
        },
        contact: {
            required: true,
            unblank: [],
            illegalCharacter: ['，-（）'],
            maxlength: 25
        },
        contactPhone: {
            required: true,
            phone: [],
            maxlength: 20
        },
        useType: {
            required: true
        },
        bgImg: {
            required: true
        }
    };
    var addValidator = $('#addTemplateForm').validateForm(rules);
    $.ajax({
        type: "POST",
        dataType: 'json',
        url: ctx + "/system/dictionary/listValues.action?groupKey=templateUseType",
        data: {},
        async: false,
        success: function (result) {
            // 初始下拉框
            $('#useType').select2({
                // placeholder : '请选择',
                // allowClear : true,
                language: 'zh-CN',
                data: result.items,
                minimumResultsForSearch: -1,// 去掉搜索框
                // 选中项回调
                templateSelection: function (selection) {
                    addValidator.form();
                    return selection.text;
                }
            });
            $('#useType').prop('disabled', true);
            $('#useType').val('0').trigger("change");
        }
    });

    $.ajax({
        type: "POST",
        dataType: 'json',
        url: ctx + "/creditTemplate/bgImgList.action",
        data: {},
        async: false,
        success: function (result) {
            // 初始下拉框
            $('#bgImg').select2({
                // placeholder : '请选择',
                // allowClear : true,
                language: 'zh-CN',
                data: result.items,
                minimumResultsForSearch: -1,// 去掉搜索框
                // 选中项回调
                templateSelection: function (selection) {
                    addValidator.form();
                    return selection.text;
                }
            });
        }
    });

    $('input[name="isDefault"]').iCheck({
        checkboxClass: 'icheckbox_square-blue',
        radioClass: 'iradio_square-blue',
        increaseArea: '20%'
    });
    $('input[name="category"]').iCheck({
        checkboxClass: 'icheckbox_square-blue',
        radioClass: 'iradio_square-blue',
        increaseArea: '20%'
    });

    var templateId = $('#templateId_hide').val();// 模板id
    var opType = $('#opType_hide').val();// 操作类型（add：新增，read：查看，update：修改）
    if (opType == 'add') {
        $('#info_title').html('新建信用报告模板');
    } else if (opType == 'update') {
        $('#info_title').html('编辑信用报告模板');
    }

    // 左侧树配置项
    var setting = {
        treeId: "id",
        async: {
            enable: true,
            url: ctx + '/creditTemplate/tree.action?templateId=' + templateId + '&opType=' + opType + '&zyyt=0',
            type: "post"
        },
        data: {
            key: {
                name: "text",
            }
        },
        check: {
            enable: true,
            chkDisabledInherit: true,
            nocheckInherit: true
        },
        view: {
            addDiyDom: function addDiyDom(treeId, treeNode) {
                var aObj = $("#" + treeNode.tId + "_a");
                var nodeSpan = $($("#" + treeNode.tId + "_span"));
                var spantxt = nodeSpan.html();
                var len = 15;// 一级节点超出长度（以中文计算）
                var lenC = 13;// 一级节点保留长度
                if (treeNode.level == 1) {
                    len = 14;// 二级节点超出长度
                    lenC = 12;// 二级节点保留长度
                }
                if (spantxt.length > len) {
                    spantxt = spantxt.substring(0, lenC) + "...";
                    nodeSpan.html(spantxt);
                }

                var editHtml = '<input onclick="stopBubble();" id="' + treeNode.tId + '_input" value="' + treeNode.displayOrder
                    + '" style="width:32px;height:17px;display:none;" onkeyup="this.value=this.value.replace(/[^0-9]*/g,\'\');" />';
                aObj.append(editHtml);
            }
        },
        callback: {
            onAsyncSuccess: function () { // 展开一级二级节点
                var treeObj = $.fn.zTree.getZTreeObj("themeTree");
                allNodes = treeObj.transformToArray(zTreeObj.getNodes());
                expandTreeNode();
                bindClickEvent();

                if (opType == 'update') {// 修改操作
                    // 加载已有资源数据
                    var oldThemeNodeArr = $.evalJSON(tempalteThemeList);
                    $.each(oldThemeNodeArr, function (i, oldThemeNode) {
                        if (oldThemeNode.type == '1') {
                            oldThemeNode.checked = false;
                        } else if (oldThemeNode.type == '2') {
                            oldThemeNode.checked = true;
                        }
                        checkedThemesMap.put(oldThemeNode.id, oldThemeNode);
                    });

                    // 加载已有字段数据
                    var oldColumnArr = $.evalJSON(tempalteThemeColumnList);
                    $.each(oldColumnArr, function (i, checkedColumn) {
                        var checkedColumnMap = checkedThemeColumnsMap.get(checkedColumn.themeId);
                        if (isNull(checkedColumnMap)) {
                            checkedColumnMap = new Map();
                        }
                        checkedColumnMap.put(checkedColumn.columnName, checkedColumn);
                        checkedThemeColumnsMap.put(checkedColumn.themeId, checkedColumnMap);
                    });
                }

            },
            beforeClick: function (treeId, treeNode, clickFlag) {
                if (nEditing != null) {
                    saveRow(nEditing);// 保存先前处于编辑中的数据
                }
                return true;
            },
            onClick: function (event, treeId, node) { // 单击节点刷新列表
                zTreeObj.checkNode(node, true, true, true);
                refreshTable(node);
            },
            onExpand: function (event, treeId, node) {
                // 如果资源节点处于编辑状态，则显示子节点的顺序输入框
                if ($('#saveThemeDisplayOrder').is(':visible')) {
                    $.each(node.children, function (i, child) {
                        $('#' + child.tId + '_input').show();
                        $('#' + child.tId + '_input').val(child.displayOrder);
                    });
                }
            },
            onCheck: onTreeCheck
        }
    };

    var zTreeObj = $.fn.zTree.init($("#themeTree"), setting);
    var allNodes = [];

    function expandTreeNode() {
        var treeObj = $.fn.zTree.getZTreeObj("themeTree");
        var root = treeObj.getNodes()[0];
        treeObj.expandNode(root, true);
        var children = root.children;
        if (children) {
            for (var i = 0, len = children.length; i < len; i++) {
                var child = children[i];
                treeObj.expandNode(child, true);
            }
        }
    }

    // 编辑顺序和保存顺序添加绑定事件
    function bindClickEvent() {
        // 编辑顺序
        $('#editThemeDisplayOrder').click(function () {
            $.each(allNodes, function (i, node) {
                $('#' + node.tId + '_input').show();
            });
            $('#editThemeDisplayOrder').hide();
            $('#saveThemeDisplayOrder').show();
        });

        // 保存顺序
        $('#saveThemeDisplayOrder').click(saveThemeDisplayOrder);
    }

    // 保存顺序
    function saveThemeDisplayOrder() {
        // 校验输入框中的值是否为数字
        var passFlag = true;
        $.each(allNodes, function (i, node) {
            if ($('#' + node.tId + '_input').is(':visible')) {
                var val = $('#' + node.tId + '_input').val();
                passFlag = /^[1-9]\d*$/.test(val);// 校验输入框中是否为数字
                if (!passFlag) {
                    $('#' + node.tId + '_input').val(node.displayOrder);// 重置输入框的值
                    return false;
                }
            }
        });
        if (!passFlag) {
            $.alert('资源显示顺序只能为正整数！', 2);
            return false;
        }
        // 保存值在变量中
        $.each(allNodes, function (i, node) {
            if ($('#' + node.tId + '_input').is(':visible')) {
                var val = $('#' + node.tId + '_input').val();
                node.displayOrder = val;
                var checkedNode = checkedThemesMap.get(node.id);
                if (!isNull(checkedNode)) {
                    checkedNode.displayOrder = node.displayOrder;
                    checkedThemesMap.put(node.id, checkedNode);
                }
                $('#' + node.tId + '_input').hide();
            }
        });

        // 排序
        allNodes.sort(function (a, b) {
            return a.displayOrder - b.displayOrder;
        });

        // 刷新树
        var zTreeNodes = [];
        $.each(allNodes, function (i, node) {
            if (node.type == '1') {
                zTreeNodes.push(node);
            }
        });
        zTreeObj = $.fn.zTree.init($("#themeTree"), $.fn.extend({}, setting, {
            async: {
                enable: false
            }
        }), zTreeNodes);
        allNodes = zTreeObj.transformToArray(zTreeObj.getNodes());
        $('#saveThemeDisplayOrder').hide();
        $('#editThemeDisplayOrder').show();
        return true;
    }

    // 树节点复选框事件函数
    function onTreeCheck(event, nodeId, node) {
        // 父节点
        var parentNode = node.getParentNode();
        var children = node.children;
        if (node.checked) {
            // 记录选中的资源
            checkedThemesMap.put(node.id, node);

            // 若是二级节点，添加其父节点（即一级节点）到选中的节点中
            if (node.type == '2') {
                checkedThemesMap.put(parentNode.id, parentNode);
            }
            // 若是一级节点，添加其所有子节点（即二级节点）到选中的节点中
            if (node.type == '1' && !isNull(children)) {
                $.each(children, function (idx, item) {
                    checkedThemesMap.put(item.id, item);
                });
            }
        } else {
            // 移除该资源的选中记录
            checkedThemesMap.remove(node.id);

            // 若是二级资源，移除二级资源的字段信息
            if (node.type == '2') {
                checkedThemeColumnsMap.remove(node.id);
                // 判断是否需要移除其父节点一级资源的选中记录
                var flag = true;
                // 获取其兄弟节点
                var siblings = parentNode.children;
                if (!isNull(siblings)) {
                    $.each(siblings, function (idx, item) {
                        if (checkedThemesMap.containsKey(item.id)) {
                            // 如果选中的记录中有其兄弟节点时选中状态，则不移除其父节点的选中状态
                            flag = false;
                            return;
                        }
                    });
                }

                if (flag) {
                    // 移除父节点的选中记录
                    checkedThemesMap.remove(parentNode.id);
                }
            }
            // 若是一级节点，移除其下二级资源的所有资源及字段信息
            if (node.type == '1' && !isNull(children)) {
                $.each(children, function (idx, item) {
                    checkedThemesMap.remove(item.id);
                    checkedThemeColumnsMap.remove(item.id);
                });
            }
        }
    }

    var table = $('#themeColumnGrid').DataTable({// 创建一个Datatable
        // destroy : true,// 如果需要重新加载的时候请加上这个
        dom: 'lfrtip',
        lengthChange: false,// 是否允许用户改变表格每页显示的记录数
        searching: false,// 是否允许Datatables开启本地搜索
        ordering: false,
        autoWidth: false,
        paging: false, // 禁用分页
        data: {},
        // 使用对象数组，一定要配置columns，告诉 DataTables 每列对应的属性
        // data 这里是固定不变的
        columns: [{
            "data": null
        }, {
            "data": "columnComments"
        }, {
            "data": "columnAlias"
        }, {
            "data": "displayOrder"
        }, {
            "data": null
        }],
        columnDefs: [{
            targets: 0, // checkBox
            render: function (data, type, row) {
                return '<input type="checkbox" name="checkThis" class="icheck">';
            }
        }, {
            targets: 4, // 操作
            render: function (data, type, row) {
                return '<button type="button" class="edit btn green btn-xs">编辑顺序</button>';
            }
        }],
        initComplete: initComplete,
        drawCallback: drawCallback
    });

    // 字段列表复选框选中事件
    function onGridCheck(rowData) {
        var columnMap = checkedThemeColumnsMap.get(rowData.themeId);
        if (isNull(columnMap)) {
            columnMap = new Map();
        }
        columnMap.put(rowData.columnName, rowData);
        checkedThemeColumnsMap.put(rowData.themeId, columnMap);
    }

    // 字段列表复选框取消选中事件
    function onGridUnCheck(rowData) {
        var columnMap = checkedThemeColumnsMap.get(rowData.themeId);
        columnMap.remove(rowData.columnName);
        checkedThemeColumnsMap.put(rowData.themeId, columnMap);
    }

    function drawCallback(settings) {
        $('#checkall, #themeColumnGrid tbody .icheck').iCheck({
            labelHover: false,
            cursor: true,
            checkboxClass: 'icheckbox_square-blue',
            radioClass: 'iradio_square-blue',
            increaseArea: '20%'
        });

        // 列表复选框选中取消事件
        var checkAll = $('#checkall');
        var checkboxes = $('#themeColumnGrid tbody .icheck');
        checkAll.on('ifChecked ifUnchecked', function (event) {
            if (event.type == 'ifChecked') {
                checkboxes.iCheck('check');
                $('#themeColumnGrid tbody tr').addClass('active');
                // 添加字段选中记录
                $.each(table.data(), function (rowIndex, rowData) {
                    onGridCheck(rowData);
                });
            } else {
                checkboxes.iCheck('uncheck');
                $('#themeColumnGrid tbody tr').removeClass('active');
                // 取消字段选中记录
                $.each(table.data(), function (rowIndex, rowData) {
                    onGridUnCheck(rowData);
                });
            }
        });
        checkboxes.on('ifChanged', function (event) {
            if (checkboxes.filter(':checked').length == checkboxes.length) {
                checkAll.prop('checked', 'checked');
            } else {
                checkAll.removeProp('checked');
            }
            checkAll.iCheck('update');
            if ($(this).is(':checked')) {
                $(this).closest('tr').addClass('active');
                onGridCheck(table.row($(this).closest('tr')).data());
            } else {
                $(this).closest('tr').removeClass('active');
                onGridUnCheck(table.row($(this).closest('tr')).data());
            }
        });
    }

    // Datatables初始化完成后执行的方法
    function initComplete(settings, json) {
        // 添加编辑按钮点击事件
        $('#themeColumnGrid tbody').on('click', '.edit', function (e) {
            stopBubble(e);
            var nRow = $(this).parents('tr')[0];
            if (nEditing != null && nEditing != nRow) {// 前一个编辑中的行不是当前选中行
                saveRow(nEditing);// 保存前先数据
                editRow(nRow);// 开始编辑当前行
                nEditing = nRow;
            } else if (nEditing == nRow && $(this).html() == '保存') {
                saveRow(nEditing);
                nEditing = null;
            } else {
                editRow(nRow);
                nEditing = nRow;
            }
        });
    }

    // 编辑
    function editRow(nRow) {
        var td = $('>td', nRow).eq(3);
        var data = table.cell(td).data();
        $(td).html('<input type="text" onblur="templeteConfig.saveEditValueOnblur();" class="form-control input-sm" style="width:100%" placeholder="请输入正整数" value="' + nullToEmpty(data) + '">');
    }

    // 保存
    function saveRow(nRow) {
        var input = $(nRow).find('input[type="text"]')[0];
        var val = $(input).val();
        var tds = $('>td', nRow);
        table.cell(tds[3]).data(val);
        table.cell(tds[4]).data(table.cell(tds[4]).data());
        table.draw();
    }

    // 字段顺序编辑状态-失去光标事件
    function saveEditValueOnblur() {
        // 结束表格编辑状态
        if (nEditing != null) {
            saveRow(nEditing);// 保存先前处于编辑中的数据
        }
    }

    // 获取选中的二级资源对应的数据源下对应表的所有字段
    function refreshTable(node) {
        var themeId = node.id;
        nEditing = null;
        table.clear().draw();
        if (node.type == 2) {// 二级资源
            $.getJSON(ctx + '/creditTemplate/templateColumnlist.action', {
                themeId: themeId,
                templateId: templateId
            }, function (result) {
                $('#checkall').iCheck('uncheck');
                table.rows.add(result);

                // 切换资源，字段数据加载成功后，回填编辑过的显示顺序信息，以及勾选过的状态
                if (!isNull(checkedThemeColumnsMap.get(themeId))) {
                    var checkedColumnsArr = checkedThemeColumnsMap.get(themeId).values();
                    if (!isNull(checkedColumnsArr)) {
                        $.each(result, function (idx, row) {
                            $.each(checkedColumnsArr, function (index, columnData) {
                                if (row.columnName == columnData.columnName) {
                                    table.row(idx).data(columnData);
                                    return;// 跳出内层循环
                                }
                            });
                        });
                    }
                }
                table.draw();

                // 表格重绘后，设置数据选中状态(重绘前设置选中状态的话，重绘后就没有了)
                if (!isNull(checkedThemeColumnsMap.get(themeId))) {
                    var checkedColumnsArr = checkedThemeColumnsMap.get(themeId).values();
                    if (!isNull(checkedColumnsArr)) {
                        $.each(result, function (idx, row) {
                            var rowNode = table.row(idx).node();
                            $.each(checkedColumnsArr, function (index, columnData) {
                                if (row.columnName == columnData.columnName) {
                                    $(rowNode).find('.icheck').iCheck('check');
                                    return;// 跳出内层循环
                                }
                            });
                        });
                    }
                }
            });
        }
    }

    // 校验要保存的数据
    function checkData() {
        if (!addValidator.form()) {
            $.alert("表单验证不通过，无法提交！", 2);
            return;
        }

        if (checkedThemesMap.size() == 0) {
            $.alert('请勾选需要配置的资源信息！', 2);
            return false;
        }
        if (checkedThemeColumnsMap.size() == 0) {
            $.alert('请勾选需要配置的字段信息！', 2);
            return false;
        }

        var passFlag = true;
        $.each(checkedThemesMap.keys(), function (idx, themeId) {
            var theme = checkedThemesMap.get(themeId);
            // check是否有选中的资源，没有配置任何字段
            var columnMap = checkedThemeColumnsMap.get(themeId);
            var nodes = zTreeObj.getSelectedNodes();
            $.each(nodes, function (i, node) {
                if (theme.type == '1' && node.id == themeId && isNull(node.children)) {
                    $.alert('一级资源【' + theme.text + '】下尚未勾选任何二级资源，不能选择！', 2);
                    passFlag = false;
                    return false;
                }
            });

            if (theme.type == '2' && (isNull(columnMap) || columnMap.size() == 0)) {
                $.alert('二级资源【' + theme.text + '】尚未勾选任何字段！', 2);
                passFlag = false;
                return false;// return
                // 在$.each()方法中的作用只是打断循环，而不会跳出checkData()方法
            }

            // check选中资源的显示顺序是否已经正确填写
            if (isNull(theme.displayOrder)) {
                var msg = '';
                if (theme.type == '1') {
                    msg = '一级资源【' + theme.text + '】';
                } else if (theme.type == '2') {
                    msg = '二级资源【' + theme.text + '】';
                }
                $.alert('左侧树中' + msg + '的显示顺序未正确填写！', 2);
                passFlag = false;
                return false;// return
                // 在$.each()方法中的作用只是打断循环，而不会跳出checkData()方法
            }
        });

        if (!passFlag) {
            return false;
        }

        // check选中资源下的字段显示顺序是否正确填写
        $.each(checkedThemeColumnsMap.keys(), function (idx, themeId) {
            var theme = checkedThemesMap.get(themeId);
            var columnMap = checkedThemeColumnsMap.get(themeId);
            if (!isNull(columnMap)) {
                if (columnMap.size() == 0) {
                    $.alert('请选择资源【' + theme.text + '】的字段信息！', 2);
                    passFlag = false;
                    return false;
                }
                $.each(columnMap.keys(), function (idx, columnName) {
                    var columnNode = columnMap.get(columnName);
                    if (isNull(columnNode.displayOrder) || !/^[1-9]\d*$/.test(columnNode.displayOrder)) {
                        $.alert('资源【' + theme.text + '】的字段【' + columnNode.columnAlias + '】的显示顺序不能为空，且必须为正整数！', 2);
                        passFlag = false;
                        return false;
                    }
                });
                if (!passFlag) {
                    return false;
                }
            }
        });
        if (!passFlag) {
            return false;
        }

        return true;
    }

    // 保存配置
    function configure() {
        // 结束表格编辑状态
        saveEditValueOnblur();

        // check
        if (!checkData()) {
            return;
        }

        // 资源顺序是否保存
        if ($('#saveThemeDisplayOrder').is(':visible')) {
            layer.confirm('资源顺序处于编辑状态，点击【确定】将保存新的顺序，点击【取消】返回。', {
                icon: 3
            }, function (index) {
                layer.close(index);
                if (saveThemeDisplayOrder()) {
                    sendSaveRequest();
                }
            });
        } else {
            sendSaveRequest();
        }
    }

    function sendSaveRequest() {
        // 给资源模板配置的所有列字段信息
        var checkedThemeColumnArr = [];
        $.each(checkedThemeColumnsMap.values(), function (idx, columnMap) {
            checkedThemeColumnArr = checkedThemeColumnArr.concat(columnMap.values());
        });

        var checkedThemesStr = $.toJSON(checkedThemesMap.values());
        var checkedThemeColumnsStr = $.toJSON(checkedThemeColumnArr);
        loading();
        $.ajax({
            url: ctx + '/creditTemplate/configureTemplate.action',
            data: {
                templateId: templateId,
                opType: opType,
                checkedThemesStr: checkedThemesStr,
                checkedThemeColumnsStr: checkedThemeColumnsStr,
                creditName: $('#creditName').val(),
                reportTitle: $('#reportTitle').val(),
                useType: $('#useType').val(),
                bgImg: $('#bgImg').val(),
                isDefault: $('input[name="isDefault"]:checked').val(),
                category: $('input[name="category"]:checked').val(),
                address: $('#address').val(),
                reportSource: $('#reportSource').val(),
                contact: $('#contact').val(),
                contactPhone: $('#contactPhone').val()
            },
            dataType: 'json',
            type: 'POST',
            success: function (data) {
                loadClose();
                if (data.result) {
                    $.alert('保存成功！', 1, function () {
                        goBack();
                    });
                } else {
                    $.alert(data.message, 2);
                }
            },
            error: function () {
                loadClose();
                $.alert('保存失败', 2);
            }
        });
    }

    function goBack() {
        AccordionMenu.openUrl('信用报告模板', ctx + '/creditTemplate/creditTemplate.action');
    }

    $(function () {
        if (!isNull(template)) {
            template = $.evalJSON(template);
            $('#creditName').val(template.creditName);
            $('#reportTitle').val(template.title);
            $('#useType').val(template.useType).trigger('change');
            $('#bgImg').val(template.bgImg).trigger('change');
            $('#address').val(template.address);
            $('#reportSource').val(template.reportSource);
            $('#contact').val(template.contact);
            $('#contactPhone').val(template.contactPhone);
            if (template.isDefault == 0) {
                $('input[name="isDefault"][value=0]').iCheck('check');
            } else if (template.isDefault == 1) {
                $('input[name="isDefault"][value=1]').iCheck('check');
            }
            if (template.category == 0) {
                $('input[name="category"][value=0]').iCheck('check');
            } else if (template.category == 1) {
                $('input[name="category"][value=1]').iCheck('check');
            }
            addValidator.form();
        }
    });

    return {
        goBack: goBack,
        configure: configure,
        saveEditValueOnblur: saveEditValueOnblur
    }
})();
