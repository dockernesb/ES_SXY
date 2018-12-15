var dataReportCetl = (function () {
    function initcanves(steps, stepHops, idStr) {
        var canvas = document.getElementById(idStr);
        var stage = new JTopo.Stage(canvas);
        // 显示工具栏
        scene = new JTopo.Scene(stage);
        var steps = jQuery.parseJSON(steps);
        var hops = jQuery.parseJSON(stepHops);
        var nodes = [];

        // 节点
        function newNode(x, y, w, h, text, code, stepMsg) {
            var node = new JTopo.Node(text);
            node.setLocation(x, y);
            node.setSize(w, h);
            scene.add(node);
            node.fontColor = 'red';
            node.setBound(x, y, 30, 30); // 同时设置大小及位置
            node.setImage(ctx + '/app/images/cetlIcon/' + code + '.png');
            node.borderWidth = 1; // 边框的宽度
            node.textOffsetY = 3;
            node.borderRadius = 5;
            node.borderColor = '8,46,84'; // 边框颜色
            node.addEventListener("click", function () {
                // this.
                // var detail = '';
                if (!isNull(stepMsg)) {
                    // 提示层
                    layer.msg(stepMsg);
                }
            });

            return node;
        }

        // 简单连线
        function newLink(nodeA, nodeZ, text, dashedPattern) {
            var link = new JTopo.Link(nodeA, nodeZ, text);
            link.lineWidth = 1; // 线宽
            link.dashedPattern = dashedPattern; // 虚线
            link.bundleOffset = 60; // 折线拐角处的长度
            link.bundleGap = 20; // 线条之间的间隔
            link.textOffsetY = 3; // 文本偏移量（向下3个像素）
            link.strokeColor = '8,46,84';
            scene.add(link);
            return link;
        }

        //将图标平移
        var valuex = 0;
        var valuey = 0;

        $.each(steps.rows, function (i, n) {
            var x = n.GUI_LOCATION_X;
            if (valuex == 0 || x < valuex) {
                valuex = x;
            }

            var y = n.GUI_LOCATION_Y;
            if (valuey == 0 || y < valuex) {
                valuey = y;
            }

        })

        valuex -= 50;
        valuey -= 50;

        $.each(steps.rows, function (i, n) {
            nodes[n.ID_STEP] = newNode(n.GUI_LOCATION_X - valuex, n.GUI_LOCATION_Y - valuey, 30, 30, n.NAME, n.CODE, n.stepMsg)
        })
        $.each(hops.rows, function (i, n) {
            var from = nodes[n.ID_STEP_FROM];
            var to = nodes[n.ID_STEP_TO];
            scene.add(from);
            scene.add(to);
            var link = newLink(from, to);
            link.arrowsRadius = 10;
        });
    }
    ;

    function scrollFunc() {
        $("#nodepop").hide();
    }

    if (document.addEventListener) {
        document.addEventListener('DOMMouseScroll', scrollFunc, false);
    }// W3C
    window.onmousewheel = document.onmousewheel = scrollFunc;// IE/Opera/Chrome/Safari

    window.addEventListener("resize", resizeCanvas, false);

    function resizeCanvas() {
        var canvas = document.getElementById("canvas");
        var canvas2 = document.getElementById("canvas2");
        canvas.width = window.innerWidth - 60;
        canvas.height = window.innerHeight;

        canvas2.width = window.innerWidth - 60;
        canvas2.height = window.innerHeight;
    }

    function showDataReportCetl() {
        var url = ctx + "/dp/cetlInfo/getTaskCetl.action";
        $.post(url, {
            tableCode: $('#tableCode').val(),
            showLog: $('#showLog').val()
        }, function (data) {
            if (data == 'error') {
                $.alert("操作异常，请稍后再试！");
                return;
            }
            var dataarr = data.split("$$");
            var y2xsteps = dataarr[1];
            var y2xstepHopList = dataarr[2];
            if (y2xsteps != '') {
                initcanves(y2xsteps, y2xstepHopList, 'canvas');
            }

            var x2wsteps = dataarr[3];
            var x2wstepHopList = dataarr[4];
            if (x2wsteps != '') {
                initcanves(x2wsteps, x2wstepHopList, 'canvas2');
            }
            parent.loadClose();
        }, "text");
    }

    showDataReportCetl();
    resizeCanvas();

    return {
        "showDataReportCetl": showDataReportCetl
    }
})();