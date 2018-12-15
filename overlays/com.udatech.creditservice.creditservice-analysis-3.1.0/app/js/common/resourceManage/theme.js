var creditTheme = function () {
    var rules = {
        typeName: {
            required: true,
            unblank: [],
            illegalCharacter: ['-'],
            maxlength: 10
        },
        displayOrder: {
            required: true,
            cipint: [],
            maxlength: 9
        }
    };
    var addValidator = $('#addForm').validateForm(rules);
    var editValidator = $('#editForm').validateForm(rules);

    function initParentTheme() {
        $('#parentTheme, #parentTheme_edit').find('option').remove();// 先重置下拉框
        $.ajax({
            type: "POST",
            dataType: 'json',
            url: ctx + "/theme/getAllFirstTheme.action",
            data: {},
            async: false,
            success: function (result) {
                var optionHtml = '';
                $.each(result.top, function (i, top) {
                    optionHtml += '<optgroup label="' + top.typeName + '">';
                    $.each(result.children, function (j, first) {
                        if (top.id == first.parentId) {
                            optionHtml += '<option value="' + first.id + '" data-zyyt="' + first.zyyt + '">' + first.typeName + '</option>';
                        }
                    });
                    optionHtml += '</optgroup>';
                });

                $('#parentTheme, #parentTheme_edit').html(optionHtml);
                // 初始下拉框
                $('#parentTheme, #parentTheme_edit').select2({
                    language: 'zh-CN'
                });
                $("#parentTheme").change(function (o) {
                    // 选中父级资源时，将子资源的资源用途设置与父资源相同
                    var zyyt = $("#parentTheme").find('option:selected').attr('data-zyyt');
                    if (zyyt) {
                        $('#zyyt').val(zyyt).trigger("change");
                    }
                });
                $("#parentTheme_edit").change(function (o) {
                    // 选中父级资源时，将子资源的资源用途设置与父资源相同
                    var zyyt = $("#parentTheme_edit").find('option:selected').attr('data-zyyt');
                    if (zyyt) {
                        $('#zyyt_edit').val(zyyt).trigger("change");
                    }
                });
                resizeSelect2('#parentTheme, #parentTheme_edit');
                $('#parentTheme, #parentTheme_edit').val(null).trigger("change");
            }
        });
    }

    // 初始化资源用途下拉框
    // 取资源表中的顶级资源作为资源用途
    function initZyyt(type) {
        $('#zyyt, #zyyt_edit').find('option').remove();// 先重置下拉框
        $.ajax({
            type: "POST",
            dataType: 'json',
            url: ctx + "/theme/getAllFirstTheme.action",
            data: {},
            async: false,
            success: function (result) {
                var optionHtml = '';
                $.each(result.top, function (i, top) {
                    optionHtml += '<option value="' + top.zyyt + '" data-id="' + top.id + '">' + top.typeName + '</option>';
                });

                $('#zyyt, #zyyt_edit').html(optionHtml);
                // 初始下拉框
                $('#zyyt, #zyyt_edit').select2({
                    language: 'zh-CN',
                    minimumResultsForSearch: -1
                    // 去掉搜索框
                });
                $("#zyyt, #zyyt_edit").change(function () {
                    if (type == 0) {// add
                        addValidator.form();
                    } else {// edit
                        editValidator.form();
                    }
                });
                resizeSelect2('#zyyt, #zyyt_edit');
                $('#zyyt, #zyyt_edit').val(null).trigger("change");
            }
        });
    }

    function initDataSource() {
        $('#dataSource, #dataSource_edit').find('option').remove();// 先重置下拉框
        $.ajax({
            type: "POST",
            dataType: 'json',
            url: ctx + "/system/dictionary/listValues.action?groupKey=dataSource",
            data: {},
            async: false,
            success: function (result) {
                // 初始下拉框
                $('#dataSource, #dataSource_edit').select2({
                    language: 'zh-CN',
                    data: result.items,
                    minimumResultsForSearch: -1
                    // 去掉搜索框
                });
                resizeSelect2('#dataSource, #dataSource_edit');
                $('#dataSource, #dataSource_edit').val(null).trigger("change");
            }
        });
    }

    function initDataTable(ds) {
        $('#dataTable, #dataTable_edit').find('option').remove();// 先重置下拉框
        $.ajax({
            type: "POST",
            dataType: 'json',
            url: ctx + "/theme/allTables.action",
            data: {
                ds: $(ds).val()
            },
            async: false,
            success: function (result) {
                // 初始下拉框
                $('#dataTable, #dataTable_edit').select2({
                    language: 'zh-CN',
                    data: result.items,
                    templateResult: function (state) {
                        if (!state.id) {
                            return state.text;
                        }
                        var $state = $('<span>' + state.element.value + '<br>' + state.text + '</span>');
                        return $state;
                    }
                });
                resizeSelect2('#dataTable, #dataTable_edit');
                $('#dataTable, #dataTable_edit').val(null).trigger("change");
            }
        });
    }

    function initICheck() {
        $('input[name="type"]').iCheck({
            labelHover: false,
            checkboxClass: 'icheckbox_square-blue',
            radioClass: 'iradio_square-blue',
            increaseArea: '20%'
        });
        // 资源类型选中事件
        $('input[name="type"]').on('ifChecked', function (event) {
            $('#zyyt, #zyyt_edit').val(null).trigger("change");
            if ($(event.target).val() == 2) {
                $('#dataTable, #dataTable_edit').find('option').remove();
                $('#dataTable, #dataTable_edit').prop('disabled', false);
                $('#dataSource, #dataSource_edit').prop('disabled', false);
                $('#parentTheme, #parentTheme_edit').prop('disabled', false);
                $('#zyyt, #zyyt_edit').prop('disabled', true);
                // 移除必填标示红*
                $('#dataTable, #dataTable_edit').closest('.form-group').find('.required').remove();
                $('#dataSource, #dataSource_edit').closest('.form-group').find('.required').remove();
                $('#parentTheme, #parentTheme_edit').closest('.form-group').find('.required').remove();
                // 添加必填标示红*
                $('#dataTable, #dataTable_edit').closest('.form-group').find('label').prepend('<span class="required">*</span> ');
                $('#dataSource, #dataSource_edit').closest('.form-group').find('label').prepend('<span class="required">*</span> ');
                $('#parentTheme, #parentTheme_edit').closest('.form-group').find('label').prepend('<span class="required">*</span> ');
            } else {
                $('#dataTable, #dataTable_edit').val(null).trigger("change");
                $('#dataSource, #dataSource_edit').val(null).trigger("change");
                $('#parentTheme, #parentTheme_edit').val(null).trigger("change");
                $('#dataTable, #dataTable_edit').prop('disabled', true);
                $('#dataSource, #dataSource_edit').prop('disabled', true);
                $('#parentTheme, #parentTheme_edit').prop('disabled', true);
                $('#zyyt, #zyyt_edit').prop('disabled', false);
                // 移除必填标示红*
                $('#dataTable, #dataTable_edit').closest('.form-group').find('.required').remove();
                $('#dataSource, #dataSource_edit').closest('.form-group').find('.required').remove();
                $('#parentTheme, #parentTheme_edit').closest('.form-group').find('.required').remove();
            }
        });
    }

    function addTheme() {
        $('#addForm')[0].reset();
        initParentTheme();
        initZyyt(0);
        initDataSource();
        initICheck();
        $('#first').iCheck('check');
        $('#dataTable').select2({
            language: 'zh-CN'
        });
        resizeSelect2('#dataTable');

        // 数据源改变后重新加载数据表数据
        $('#dataSource').on('select2:select', function () {
            $('#dataTable').find('option').remove();
            initDataTable('#dataSource');
        });

        $.openWin({
            title: '添加资源',
            content: $("#addDiv"),
            area: ['600px', '500px'],
            yes: function (index, layero) {
                addSubmit(index);
            }
        });
        addValidator.form();
    }

    // 添加一级资源-确定按钮事件
    function addSubmit(index) {
        if (!addValidator.form()) {
            $.alert("资源名称不能为空！");
            return;
        }
        if (isNull($('#zyyt').val())) {
            $.alert("资源用途不能为空！");
            return;
        }

        var type = $('#addForm').find('input[name=type]:checked').val();
        var parentId = $('#parentTheme').val();
        if (type == 1) {// 如果是新增一级资源，那么其父级资源一定是顶级资源，取顶级资源id
            parentId = $("#zyyt").find('option:selected').attr('data-id');
        }

        loading();
        var addFormData = {
            typeName: $.trim($('#typeName').val()),
            type: type,
            zyyt: $('#zyyt').val(),
            parentId: parentId,
            dataSource: $('#dataSource').val(),
            dataTable: $('#dataTable').val(),
            displayOrder: $("#displayOrder").val()
        };
        $.post(ctx + "/theme/saveTheme.action", addFormData, function (data) {
            loadClose();
            if (!data.result) {
                if (data.message) {
                    $.alert(data.message, 2);
                } else {
                    $.alert('添加失败！', 2);
                }
            } else {
                $.alert('添加成功！', 1);
                layer.close(index);
                zTreeObj.reAsyncChildNodes(null, "refresh");
            }
        }, "json");
    }

    // 修改资源
    function editTheme() {
        var nodes = zTreeObj.getSelectedNodes();
        if (nodes.length > 0) {
            var node = nodes[0];
            $('#editForm')[0].reset();
            initParentTheme();
            initZyyt(1);
            initDataSource();
            initICheck();
            // 数据源改变后重新加载数据表数据
            $('#dataSource_edit').on('select2:select', function () {
                $('#dataTable_edit').find('option').remove();
                initDataTable('#dataSource_edit');
            });

            $('#id').val(node.id);
            $('#parentId_edit').val(node.parentId);
            $('#typeName_edit').val(node.text);
            if (node.type == 1) {
                $('#first_edit').iCheck('check');
                $('#first_edit').iCheck('enable');
                $('#second_edit').iCheck('disable');
                $('#dataTable_edit').val(null).trigger("change");
                $('#dataSource_edit').val(null).trigger("change");
                $('#parentTheme_edit').val(null).trigger("change");
                $('#dataTable_edit').prop('disabled', true);
                $('#dataSource_edit').prop('disabled', true);
                $('#parentTheme_edit').prop('disabled', true);
                $.openWin({
                    title: '编辑资源',
                    content: $("#editDiv"),
                    area: ['600px', '500px'],
                    yes: function (index, layero) {
                        editSubmit(index);
                    }
                });
                editValidator.form();
            } else {
                $('#second_edit').iCheck('check');
                $('#first_edit').iCheck('disable');
                $('#second_edit').iCheck('enable');
                $('#dataSource_edit').val(node.dataSource).trigger("change");
                $('#parentTheme_edit').val(node.parentId).trigger("change");
                $('#parentTheme_edit').prop('disabled', true);

                $('#dataTable_edit').find('option').remove();
                initDataTable('#dataSource_edit');
                $('#dataTable_edit').val(node.dataTable).trigger("change");

                $.getJSON(ctx + '/theme/checkTheme.action', {
                    themeId: node.id
                }, function (data) {
                    // 若是已被模板引用的资源，不允许再修改数据源和表
                    if (!data.result) {
                        // 启用只读
                        $('#dataTable_edit').prop('disabled', true);
                        $('#dataSource_edit').prop('disabled', true);
                    } else {
                        // 禁用只读
                        $('#dataTable_edit').prop('disabled', false);
                        $('#dataSource_edit').prop('disabled', false);
                    }
                    $.openWin({
                        title: '编辑资源',
                        content: $("#editDiv"),
                        area: ['600px', '500px'],
                        yes: function (index, layero) {
                            editSubmit(index);
                        }
                    });
                    editValidator.form();
                });
            }
            $('#zyyt_edit').val(node.zyyt).trigger("change");
            // 修改时，如果是一级资源，并且该一级资源下存在子资源，则资源用途不允许修改
            if (node.type == 1 && node.isParent) {
                $('#zyyt_edit').prop('disabled', true);
            }
            $('#displayOrder_edit').val(node.order);
        } else {
            $.alert('请先在左边的树中选择资源节点!');
        }
    }

    function editSubmit(index) {
        if (!editValidator.form()) {
            $.alert("表单验证不通过，无法提交！");
            return;
        }

        var type = $('#editForm').find('input[name=type]:checked').val();
        var parentId = $('#parentId_edit').val();
        if (type == 1) {// 如果是一级资源，那么其父级资源一定是顶级资源，取顶级资源id
            parentId = $("#zyyt_edit").find('option:selected').attr('data-id');
        }

        loading();
        var editFormData = {
            id: $('#id').val(),
            parentId: parentId,
            typeName: $.trim($('#typeName_edit').val()),
            type: type,
            zyyt: $('#zyyt_edit').val(),
            dataSource: $('#dataSource_edit').val(),
            dataTable: $('#dataTable_edit').val(),
            displayOrder: $("#displayOrder_edit").val()
        };
        $.post(ctx + "/theme/saveTheme.action", editFormData, function (data) {
            loadClose();
            if (!data.result) {
                if (data.message) {
                    $.alert(data.message, 2);
                } else {
                    $.alert('修改失败！', 2);
                }
            } else {
                if (data.message) {
                    $.alert(data.message, 1);
                } else {
                    $.alert('修改成功！', 1);
                }
                layer.close(index);
                zTreeObj.reAsyncChildNodes(null, "refresh");
            }
        }, "json");
    }

    // 删除资源
    function deleteConfirm() {
        var nodes = zTreeObj.getSelectedNodes();
        if (nodes.length > 0) {
            var node = nodes[0];
            layer.confirm('确认要删除吗？', {
                icon: 3
            }, function (index) {
                loading();
                $.post(ctx + "/theme/deleteTheme.action", {
                    id: node.id
                }, function (data) {
                    loadClose();
                    if (!data.result) {
                        $.alert(data.message, 2);
                    } else {
                        layer.close(index);
                        $.alert(data.message, 1);
                        zTreeObj.reAsyncChildNodes(null, "refresh");
                    }
                }, "json");
            });
        } else {
            $.alert('请先在左边的树中选择要删除的资源节点!');
        }
    }

    // 左侧树配置项
    var setting = {
        treeId: "id",
        async: {
            enable: true,
            url: ctx + "/theme/tree.action",
            type: "post"
        },
        data: {
            key: {
                name: "text",
            }
        },
        view: {
            addDiyDom: function addDiyDom(treeId, treeNode) {
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
            }
        },
        callback: {
            onAsyncSuccess: function () { // 展开一级二级节点
                expandTreeNode();
            },
            beforeClick: beforeClick,
            onClick: function (event, treeId, node) { // 单击节点刷新列表
                refreshTable(node);
            }
        }
    };
    var zTreeObj = $.fn.zTree.init($("#themeTree"), setting);

    function expandTreeNode() {
        // 初始化时默认展开第一个节点
        var treeObj = $.fn.zTree.getZTreeObj("themeTree");
        var root = treeObj.getNodes()[0];
        treeObj.expandNode(root, true);
        $('#' + root.tId + '_a').addClass('cur');
        // var children = root.children;
        // if (children) {
        // for (var i = 0, len = children.length; i < len; i++) {
        // var child = children[i];
        // treeObj.expandNode(child, true);
        // }
        // }
    }

    var table = $('#themeColumnGrid').DataTable({// 创建一个Datatable
        // destroy : true,// 如果需要重新加载的时候请加上这个
        dom: 'lfrtip',
        lengthChange: false,// 是否允许用户改变表格每页显示的记录数
        searching: false,// 是否允许Datatables开启本地搜索
        ordering: true,
        autoWidth: false,
        paging: false, // 禁用分页
        data: {},
        order: [],
        // data : {},
        // 使用对象数组，一定要配置columns，告诉 DataTables 每列对应的属性
        // data 这里是固定不变的
        columns: [{
            "data": null,
            "orderable": false
        }, {
            "data": "columnName",
            "orderable": false
        }, {
            "data": "columnComments",
            "orderable": false
        }, {
            "data": "columnAlias",
            "orderable": false
        }, {
            "data": "displayOrder",
            "orderable": true
        }, {
            "data": "dataOrder",
            "render": dataOrderFmt,
            "orderable": false
        }, {
            "data": null,
            "orderable": false
        }],
        columnDefs: [{
            targets: 0, // checkBox
            render: function (data, type, row) {
                return '<input type="checkbox" name="checkThis" class="icheck">';
            }
        }, {
            targets: 6, // 操作
            render: function (data, type, row) {
                var _html = '<button type="button" class="editAlias btn green btn-xs">别名</button>';
                _html += '<button type="button" class="editOrder btn green btn-xs">顺序</button>';
                return _html;
            }
        }],
        initComplete: initComplete,
        drawCallback: drawCallback
    });

    // 格式化选择排序字段
    function dataOrderFmt(data, type, full) {
        var op = '<div class="icheck-inline"><input type="radio" name="dataOrder" class="icheck">';
        op += '<select class="form-control innerSelect">';
        op += '<option value="desc">倒序</option>';
        op += '<option value="asc">正序</option>';
        op += '</select></div>';
        return op;
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
        var checkboxes = $('#themeColumnGrid tbody input[name="checkThis"][type="checkbox"]');
        checkAll.on('ifChecked ifUnchecked', function (event) {
            if (event.type == 'ifChecked') {
                checkboxes.iCheck('check');
                $('#themeColumnGrid tbody tr').addClass('active');
            } else {
                checkboxes.iCheck('uncheck');
                $('#themeColumnGrid tbody tr').removeClass('active');
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
                $(this).closest('tr').find('input[name="dataOrder"][type="radio"], .innerSelect').prop('disabled', false);
            } else {
                $(this).closest('tr').removeClass('active');
                $(this).closest('tr').find('input[name="dataOrder"][type="radio"], .innerSelect').prop('disabled', true);
            }
        });

        // 选择排序字段列的按钮初始化
        $('input[name="dataOrder"][type="radio"]').iCheck({
            labelHover: false,
            checkboxClass: 'icheckbox_square-blue',
            radioClass: 'iradio_square-blue',
            increaseArea: '20%'
        });

        // 选择排序字段列的下拉框初始化
        $('.innerSelect').select2({
            language: 'zh-CN',
            minimumResultsForSearch: -1
        });
        resizeSelect2('.innerSelect');

        $('input[name="dataOrder"][type="radio"]').on('ifChanged', function (event) {
            var tr = $(this).closest('tr');
            if ($(this).is(':checked')) {
                table.row(tr).data().dataOrder = $(tr).find('.innerSelect').val();
            } else {
                table.row(tr).data().dataOrder = '';
            }
        });

        $('.innerSelect').on('change', function (event) {
            var tr = $(this).closest('tr');
            var radio = $(tr).find('input[name="dataOrder"][type="radio"]');
            if ($(radio).is(':checked')) {
                table.row(tr).data().dataOrder = $(this).val();
            } else {
                table.row(tr).data().dataOrder = '';
            }
        });
    }

    var nEditing = null;// 编辑中的行
    // Datatables初始化完成后执行的方法
    function initComplete(settings, json) {
        // 添加别名按钮点击事件
        $('#themeColumnGrid tbody').on('click', '.editAlias', function (e) {
            stopBubble(e);
            saveRow2(nEditing);// 保存编辑中的顺序

            var nRow = $(this).parents('tr')[0];
            if (nEditing != null && nEditing != nRow) {// 前一个编辑中的行不是当前选中行
                saveRow(nEditing);// 保存处于编辑状态的行数据
                // 改变按钮类型
                $(nEditing).find('.editAlias').html('别名');

                editRow(nRow);// 开始编辑当前行
                nEditing = nRow;
            } else if (nEditing == nRow && $(this).html() == '保存') {
                saveRow(nEditing);
                nEditing = null;
            } else {
                editRow(nRow);
                nEditing = nRow;
            }

            $(nEditing).find('.editOrder').html('顺序');
            if ($(this).html() == '别名') {
                $(this).html('保存');
            } else {
                $(this).html('别名');
            }
        });

        // 添加顺序按钮点击事件
        $('#themeColumnGrid tbody').on('click', '.editOrder', function (e) {
            stopBubble(e);
            saveRow(nEditing);// 保存编辑中的别名

            var nRow = $(this).parents('tr')[0];
            if (nEditing != null && nEditing != nRow) {// 前一个编辑中的行不是当前选中行
                saveRow2(nEditing);// 保存处于编辑状态的行数据
                // 改变按钮类型
                $(nEditing).find('.editOrder').html('顺序');

                editRow2(nRow);// 开始编辑当前行
                nEditing = nRow;
            } else if (nEditing == nRow && $(this).html() == '保存') {
                saveRow2(nEditing);
                nEditing = null;
            } else {
                editRow2(nRow);
                nEditing = nRow;
            }
            $(nEditing).find('.editAlias').html('别名');

            if ($(this).html() == '顺序') {
                $(this).html('保存');
            } else {
                $(this).html('顺序');
            }
        });
    }

    // 编辑别名
    function editRow(nRow) {
        saveRow(nRow);
        var td = $('>td', nRow).eq(3);
        var data = table.cell(td).data();
        $(td).html('<input type="text" class="form-control input-sm editAliasInput" style="width:100%;padding:0px 5px;"  value="' + nullToEmpty(data) + '">');
    }

    // 保存别名
    function saveRow(nRow) {
        var input = $(nRow).find('input[type="text"].editAliasInput')[0];
        if (input) {
            var val = $(input).val();
            var tds = $('>td', nRow);
            table.cell(tds[3]).data(val);
            table.cell(tds[4]).data(table.cell(tds[4]).data());
            table.draw();
        }
    }

    // 编辑顺序
    function editRow2(nRow) {
        saveRow2(nRow);
        var td = $('>td', nRow).eq(4);
        var data = table.cell(td).data();
        $(td).html('<input type="text" class="form-control input-sm editOrderInput" style="width:100%;padding:0px 5px;"  value="' + nullToEmpty(data) + '">');
    }

    // 保存顺序
    function saveRow2(nRow) {
        var input = $(nRow).find('input[type="text"].editOrderInput')[0];
        if (input) {
            var val = $(input).val();
            var tds = $('>td', nRow);
            table.cell(tds[4]).data(val);
            table.cell(tds[5]).data(table.cell(tds[5]).data());
            table.draw();
            // 按显示顺序排序
            table.order([4, 'asc']).draw();

            if ($(nRow).find('input[name="checkThis"][type="checkbox"]').is(':checked')) {
                $(nRow).find('input[name="dataOrder"][type="radio"], .innerSelect').prop('disabled', false);
            } else {
                $(nRow).find('input[name="dataOrder"][type="radio"], .innerSelect').prop('disabled', true);
            }
        }
    }

    // 获取选中的二级资源对应的数据源下对应表的所有字段
    function refreshTable(node) {
        nEditing = null;
        table.clear().draw();
        if (node.type == 2) {// 二级资源
            $.getJSON(ctx + '/themeColumn/list.action', {
                themeId: node.id,
                ds: node.dataSource,
                dt: node.dataTable
            }, function (result) {
                $('#checkall').iCheck('uncheck');
                table.rows.add(result.gridData);

                var idxs = [];
                $.each(result.filterData, function (index, item) {
                    $.each(result.gridData, function (i, obj) {
                        if (obj.columnName == item.columnName) {
                            item.displayOrder = item.displayOrder == 0 ? '' : item.displayOrder;
                            idxs.push(i);
                            table.row(i).data(item);
                            return;
                        }
                    });
                });
                table.draw();

                $.each(idxs, function (i, d) {
                    var row = table.row(d).node();
                    $(row).find('input[name="checkThis"][type="checkbox"]').iCheck('check');

                    var dataOrder = table.row(d).data().dataOrder;
                    if (!isNull(dataOrder)) {
                        $(row).find('input[name="dataOrder"][type="radio"]').iCheck('check');// 选中排序字段radio
                        $(row).find('.innerSelect').val(dataOrder).trigger('change');// 选中排序字段radio
                    }
                });

                // 未勾选的行 禁用排序选择
                $.each(result.gridData, function (i, obj) {
                    var row = table.row(i).node();
                    if ($(row).find('input[name="checkThis"][type="checkbox"]').is(':checked')) {
                        $(row).find('input[name="dataOrder"][type="radio"], .innerSelect').prop('disabled', false);
                    } else {
                        $(row).find('input[name="dataOrder"][type="radio"], .innerSelect').prop('disabled', true);
                    }
                });

                // 按显示顺序排序
                table.order([4, 'asc']).draw();
            });
        }
    }

    // 资源节点点击事件
    function beforeClick(treeId, node) {
        if (node.level === 0) {
            var a = $("#" + node.tId + "_a");
            if (!a.hasClass('cur')) {
                var paid = $('.ztree li a.level0.cur').attr('id');
                var pNode = zTreeObj.getNodeByTId(paid.substring(0, paid.length - 2));
                zTreeObj.expandNode(pNode, false);
                $('.ztree li a.level0.cur').removeClass('cur');
                a.addClass("cur");
            }
            zTreeObj.expandNode(node);
            $('#btn_edit,#btn_del').attr('disabled', 'disabled');// 顶级资源不允许修改，禁用编辑和删除按钮
        } else {
            $('#btn_edit,#btn_del').removeAttr('disabled');
        }
        return true;
    }

    // 保存数据到后台
    function saveColumns() {
        if (nEditing != null) {
            saveRow(nEditing);// 保存先前处于编辑中的数据
            saveRow2(nEditing);// 保存先前处于编辑中的数据
        }

        // 先做check
        var nodes = zTreeObj.getSelectedNodes();
        if (nodes.length <= 0) {
            $.alert('请选中要修改的资源！');
            return;
        }
        var datas = table.rows('.active').data();
        if (datas.length == 0) {
            $.alert('请选择需要的字段！');
            return;
        }
        // 要传递到后台的字段数组
        var selectedData = [];
        $.each(datas, function (i, data) {
            selectedData.push(data);
        });

        var themeId = nodes[0].id;
        var passFlag = true;
        var regex = new RegExp("[`~!@#$%^&*)(=}|{':;\",\.\\\\\\+\\\[\\\]\\\\/<>?！￥…【】‘’：“”，、。？＼％]");
        var regex2 = new RegExp("^[1-9][0-9]*$");
        $.each(selectedData, function (i, item) {
            // check选中字段的别名是否已经正确填写
            if (isNull(item.columnAlias) || regex.test(item.columnAlias)) {
                $.alert('字段【' + item.columnName + '】的别名不能为空，且只允许包含特殊字符（）-');
                passFlag = false;
                return false;// return 在$.each()方法中的作用只是打断循环
            }
            // check选中字段的顺序是否已经正确填写
            if (isNull(item.displayOrder) || !regex2.test(item.displayOrder)) {
                $.alert('字段【' + item.columnName + '】的显示顺序不能为空，且只能为正整数');
                passFlag = false;
                return false;// return 在$.each()方法中的作用只是打断循环
            }
        });
        if (!passFlag) {
            return false;
        }

        layer.confirm('确认要保存修改的字段吗？', {
            icon: 3
        }, function (index) {
            loading();
            $.post(ctx + "/themeColumn/saveColumns.action", {
                themeId: themeId,
                columns: JSON.stringify(selectedData)
            }, function (data) {
                loadClose();
                if (!data.result) {
                    if (isNull(data.message)) {
                        $.alert('保存失败！');
                    } else {
                        $.alert(data.message, 2);
                    }
                } else {
                    layer.close(index);
                    $.alert('保存成功！', 1);
                }
            }, "json");
        });
    }

    return {
        addTheme: addTheme,
        editTheme: editTheme,
        deleteConfirm: deleteConfirm,
        saveColumns: saveColumns
    }
}();
