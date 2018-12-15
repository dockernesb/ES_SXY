/**
 * 示例如下，所有参数均可选，都有默认值
 * $(".btn").cclUpload({
 *     type : "img", //  文件类型（img | file），默认为file
 *     supportTypes : [],	//  支持的文件类型(文件类型为img时，默认支持"jpg","jpeg","gif","bmp","png")
 *     beforeUpload : null,   //  上传前事件（返回false时，终止上传）
 *     callback : null,   //  上传完成的回调事件(参数1：当前上传的文件信息，参数2：所有的文件信息)
 *     multiple : false,  //  是否多选（默认单选替换）
 *     max : 10, //  最多选择几个文件（多选时有效,默认最多10条）
 *     showList : false,	//	是否显示预览列表（默认不显示列表）
 *     target : "",    //  预览图片或文件的容器(不指定，则显示在按钮下方。showList为true时生效)
 * });
 */


$.fn.extend({
    //  上传组件
    cclUpload: function (opts) {

        opts = opts || {};

        var url = "";
        if(opts.isExamine)
        	url = ctx + "/creditCommon/examineAjaxFileUpload.action";
        else
        	url = ctx + "/creditCommon/ajaxFileUpload.action";
        
        var $self = $(this);
        var $form = $("#ccl-upload-form");
        var $file = $("#ccl-upload-input");
        var $time = $("#ccl-upload-time");

        //	初始化form和input
        if ($form.length <= 0) {
            $form = $('<form id="ccl-upload-form" method="post" action="' + url + '" enctype="multipart/form-data"></form>');
            $file = $('<input id="ccl-upload-input" type="file" name="files" accept="*" />');
            $time = $('<input id="ccl-upload-time" type="hidden" name="time" />');
            $("body").append($form.append($file).append($time));

            //	选择文件时
            $file.change(function () {
                var current = $file.data("current");
                if (current) {

                    //	是否多选
                    if (current.multiple) {
                        //  校验文件个数
                        if (current.list.length >= current.max) {
                            var tips = current.type == "img" ? "张图片！" : "个文件！";
                            $.alert("最多上传" + current.max + tips);
                            $form[0].reset();	//	清空input
                            return;
                        }
                    } else {	//	单选
                        current.list = [];
                    }

                    // 文件格式校验
                    var temp = $(this).val();
                    var suffix = "";	//	文件后缀
                    if (temp != null && temp != '') {
                        var index = temp.lastIndexOf("\\");
                        if (index > 0) {
                            temp = temp.substring(index + 1);
                        }
                        index = temp.lastIndexOf(".");
                        suffix = temp.substring(index + 1).toLowerCase();
                        if (current.supportTypes.length > 0) {
                            if ($.inArray(suffix, current.supportTypes) == '-1') {
                                if (current.type == "img") {
                                    $.alert('请选择正确的图片格式!<br/>支持格式：[ ' + current.supportTypes.join(", ") + ' ]');
                                } else {
                                    $.alert('请选择正确的文件格式!<br/>支持格式：[ ' + current.supportTypes.join(", ") + ' ]');
                                }
                                $form[0].reset();	//	清空input
                                return;
                            }
                        }
                    } else {
                        $form[0].reset();	//	清空input
                        return;
                    }

                    //	支持H5时本地校验文件大小
                    if (window.applicationCache) {
                        var size = $file.get(0).files[0].size;
                        if (!isNaN(size)) {
                            if (suffix == "pdf") {
                                if (size > 20 * 1024 * 1024) {
                                    $.alert("上传pdf不能大于20M，请调整pdf大小后重新上传！");
                                    $form[0].reset();	//	清空input
                                    return false;
                                }
                            } else {
                        		var tips = current.type == "img" ? "图片" : "文件";
                                if (size > 10 * 1024 * 1024) {
                                    $.alert("上传" + tips + "不能大于10M，请调整" + tips + "大小后重新上传！");
                                    $form[0].reset();	//	清空input
                                    return false;
                                }
                            }
                        }
                    }

                    //	上传前事件
                    if (current.beforeUpload instanceof Function) {
                        if (!current.beforeUpload()) {
                            $form[0].reset();	//	清空input
                            return;
                        }
                    }

                    //	设置时间轴，打开加载层
                    $time.val(new Date().getTime());
                    loading();

                    //	提交文件
                    $form.ajaxSubmit({
                        success: function (result) {
                            loadClose();
                            $form[0].reset();	//	清空input

                            if (result.success && result.success.length > 0) {
                                if (!current.multiple) {	//	单选为替换
                                    current.list = [];
                                }

                                var id = new Date().getTime();
                                result.success[0]["id"] = id;
                                current.list.push(result.success[0]);

                                if (current.showList) {
                                    showFileList(result.success);
                                }
                            }
                            if (result.fail && result.fail.length > 0) {
                                var msg = "";
                                for (var i = 0, len = result.fail.length; i < len; i++) {
                                    var fail = result.fail[i];
                                    msg += fail.msg + "\n";
                                }
                                $.alert(msg);
                            }

                            if (current.callback instanceof Function) {
                                current.callback(result.success, current.list);
                            }
                        },
                        dataType: "json"
                    });

                    //	显示图片
                    function showFileList(list) {
                        var $target = $(current.target);

                        if ($target.length == 1) {

                            if (!current.multiple) {	//	单选为替换
                                $target.children().remove();
                            }

                            var html = '';
                            for (var i = 0, len = list.length; i < len; i++) {
                                var file = list[i];

                                if (current.type == "img") {
                                    html += '<div class="preview-img">';
                                    html += '<div class="gallerys">';
                                    html += '<img class="gallery-pic" style="width: 144px;height: 100px;" src="' + ctx + '/creditCommon/viewImg.action?path=' + file.path + '"onclick="$.openPhotoGallery(this)" />';
                                    html += '<div class="fa fa-trash-o delete" id="' + file.id + '"></div>';
                                    html += '<input type="hidden" name="' + current.name + 'Name" value="' + file.name + '" />';
                                    html += '<input type="hidden" name="' + current.name + 'Path" value="' + file.path + '" />';
                                    html += '</div>';
                                } else {
                                    html += '<div class="preview-file">';
                                    html += '<div class="preview-icon"><img src="' + ctx + '/app/images/icon/' + file.icon + '" /></div>';
                                    html += '<div class="preview-name">' + file.name + '</div>';
                                    html += '<div class="fa fa-trash-o delete" id="' + file.id + '"></div>';
                                    html += '<input type="hidden" name="' + current.name + 'Name" value="' + file.name + '" />';
                                    html += '<input type="hidden" name="' + current.name + 'Path" value="' + file.path + '" />';
                                    html += '</div>';
                                    html += '</div>';
                                }

                            }
                            $target.append(html);
                            // openPhotoListener($target);
                            delListener($target);
                        }
                    }

                    $(document).on('click', '#img',function () {
                        $.openPhotoGallery(this);
                    });


                    //	删除监听
                    function delListener($target) {
                        $target.find("div.delete").unbind("click").click(function () {
                            $(this).parent().parent().remove();
                            var id = $(this).attr("id");
                            if (current.list.length > 0) {
                                for (var i = 0; i < current.list.length; i++) {
                                    var temp = current.list[i];
                                    if (temp.id == id) {
                                        current.list.splice(i, 1);
                                    }
                                }
                            }
                        });
                    }

                    //	点击图片打开大图预览监听
                    // function openPhotoListener($target) {
                    //     if (current.type == "img") {
                    //         $target.find("img").unbind("click").click(function () {
                    //             var url = $(this).attr("src");
                    //             openPhoto(url);
                    //         });
                    //     }
                    // }

                }
            });
        }

        // function openPhoto(url) {//打开图片
        //     layer.photos({
        //         photos: {
        //             "title": "", // 相册标题
        //             "id": "photos", // 相册id
        //             "start": 0, // 初始显示的图片序号，默认0
        //             "data": [ // 相册包含的图片，数组格式
        //                 {
        //                     "alt": "",
        //                     "pid": 12345, // 图片id
        //                     "src": url, // 原图地址
        //                     "thumb": "" // 缩略图地址
        //                 }]
        //         },
        //         anim: 5
        //         // 0-6的选择，指定弹出图片动画类型，默认随机（请注意，3.0之前的版本用shift参数）
        //     });
        // }



        $.each($self, function (i, obj) {

            var list = [];	//	已上传的列表
            var alreadyInit = $(obj).data("alreadyInit");	//	是否被初始化过
            var name = $(obj).attr("id") || "file";

            if (!alreadyInit) {
                var cls = $self.attr("class");
                var text = $self.html();
                var $label = $('<label for="ccl-upload-input" class="' + cls + '" style="margin-left:0px">' + text + '</label>');
                var $div = $(obj).next('div.preview-img-panel');
                var list = [];

                if ($div.length <= 0) {
                    $div = $('<div class="preview-img-panel"></div>').insertAfter($(obj));
                } else if ($div.find("div.delete").length > 0) {
                    $.each($div.find("div.delete"), function (i, obj) {
                        var id = new Date().getTime() + i;
                        list.push({"id": id});
                        $(obj).attr("id", id);
                    });
                }

                $(obj).after($label);
                $(obj).hide();

                var ccl = {
                    type: opts.type || "file", //  img | file
                    supportTypes: opts.supportTypes || (opts.type == "img" ? ["jpg", "jpeg", "gif", "bmp", "png"] : []),	//  支持的文件类型
                    beforeUpload: opts.beforeUpload || null,   //  上传前事件
                    callback: opts.callback || null,   //  上传完成的回调事件
                    multiple: opts.multiple || false,  //  是否多选
                    max: isNaN(opts.max) ? 10 : parseInt(opts.max), //  最多选择几个文件
                    showList: opts.showList || false,	//	是否显示预览列表
                    target: opts.target || $div,    //  预览图片或文件的容器(不指定，则显示在按钮下方)
                    list: list,
                    name: name
                };

                if (!ccl.target.hasClass("preview-img-panel")) {
                    ccl.target.addClass("preview-img-panel");
                }

                if (!ccl.showList) {
                    $div.hide();
                }

                $label.click(function () {
                    $file.data("current", ccl);
                    var top = $label.offset().top;
                    $("form#ccl-upload-form").offset({top: top});
                });

                $(obj).data("alreadyInit", true);
                $(obj).data("target", ccl.target);
                $(obj).data("$div", ccl.target);
                $(obj).data("ccl", ccl);
            }

        });

        return $self;
    },
    //  重置上传组件
    cclResetUpload: function () {
        var $self = $(this);
        $.each($self, function (i, obj) {
            var $item = $(obj);
            var $div = $item.data("target");
            if ($div) {
                $div.children().remove();
            }
            var ccl = $(obj).data("ccl");
            if (ccl) {
                ccl.list = [];
            }
        });
        return $self;
    }
});