var creditAtlas = (function(){

/**** 搜索框自动搜索相关 ****/
	searchInfo('#search-text', '#fasearch');

	// 搜索企业信息
	var suitResults = [];
	function searchInfo(searchInputId, searchBtnId) {
		$(searchInputId).combobox({
			url : ctx + "/center/creditCubic/queryEnterpriseByName.action",
			key : "ID",
			value : "NAME",
			searchBtn : searchBtnId,
			callback : function(i, row) {
				$(searchInputId).val(row.JGQC);
				$(searchInputId).attr("QYID",row.ID);
				suitResults.push(row);
				conditionSearch();
			}
		});
	}

/**** 图谱相关 ****/
	
      
		var width = 900;
		//var height = 480;
		var tree = [];
		var container = [];
		var linkContainer = [];
		var zoom;
		var diagonal = [];
        var scaleLevel = 0.6;
        
		var rootData = [];
		var nodes = [];
		var links =[];
		var id = 0;
		
		
		var gudongData = []; // 股东信息
		var fenzhiData = []; // 分支机构
		var gaoguanData = []; // 高管信息
		var fayuanData = []; // 法院判决
		var touziData = []; // 对外投资
		
		var legendCkStatus = [];// checkbox状态
		var gudongCkStatus = [];// 股东信息checkbox状态
		var fenzhiCkStatus = [];// 分支机构checkbox状态
		var gaoguanCkStatus = []; // 高管信息checkbox状态
		var fayuanCkStatus = []; // 法院判决checkbox状态
		var touziCkStatus = []; // 对外投资checkbox状态
		
	    var touzilevel = [];// 投资层级
		var gudongLevel = [];// 股东层级
	    
	    var height = document.documentElement.clientHeight-290;
			
			
		$(document).ready(function() {
			if (isOpen) {
			    width = 1100;
			    if ( isIE() && (navigator.userAgent.indexOf('Opera') < 0)) {
	    			height = document.documentElement.clientHeight - 188;//88top+28foot
	    		} else if ((navigator.userAgent.indexOf('Firefox') >= 0) ||(navigator.userAgent.indexOf('Opera') >= 0) || (navigator.userAgent.indexOf('Chrome') >= 0) || (navigator.userAgent.indexOf('Safari') >= 0)) {
	    			height = window.innerHeight - 188;
	    	    }
                $("#tabbable").css("margin-bottom",0);
				scaleLevel = 0.7;
			}
			if (!isNull(qyid)) {
				getData(qyid,index);
			}
		});

		   // 判断浏览器是否是ie
	    function isIE() { //ie?  
	        if (window.ActiveXObject || "ActiveXObject" in window)  
	            return true;  
	        else  {
	     	   return false;  
	        }
	    }
	    
		// 后台获取数据
		function getData(id,index) {
			/*$.ajaxSetup({
		        async: false
			});*/
			$.post(ctx + "/center/creditCubic/getEnterpriseCubicInfo.action", {id : id},
				function(data) {
				    rootData[index]=data[0];
				    var hasTab = false;
				    $("#tabs li a").each(function(){
				    	if ($(this).text() == rootData[index].name) {
				    		hasTab = true;
				    		$(this).trigger("click");
				    	}
				    });
				    if (!hasTab) {
				    	 addTab(rootData[index].name);
				    }
				   
				    traverseTreeId(rootData[index]);
					addCategory(rootData[index]);

					initDraw(rootData[index], 1, index);
				}, "json");
			
		}

		// 每个节点加上对应的Category
		function addCategory(node){
			var c = node.Category;
			if (c) {
				if (node.children) {
					for (var i = 0; i < node.children.length; i++) {
						node.children[i].Category = c;
						addCategory(node.children[i]);
					}
				}
			} else {
				if (node.children) {
					for (var i = 0; i < node.children.length; i++) {
						addCategory(node.children[i]);
					}
				}
			}
		}
		
		// 初始化配置
		function initDraw(root, type, index) {
			tree[index] = d3.layout.cluster().size([ 360, 500 ]).separation(
					function(a, b) {
						return (a.parent == b.parent ? 1 : 2) / a.depth;
					});

			var svg = d3.select("#svg" + index);

			svg.attr("width", width);
			svg.attr("height", height);

			container[index] = svg.append("g");
			linkContainer[index] = container[index].append("g");
			zoom = d3.behavior.zoom().scaleExtent([ 0.2, 4 ])
					.on("zoom", zoomed);
			diagonal[index] = d3.svg.diagonal.radial().projection(function(d) {
				return [ d.y, d.x / 180 * Math.PI ];
			});

			svg.call(zoom);

			initLocation();

			function zoomed() {
				container[index].attr("transform", "translate(" + d3.event.translate
						+ ")scale(" + d3.event.scale + ")");
			}

			function initLocation() {
				zoom.translate([ width / 2, height / 2 ]);
				zoom.scale(scaleLevel);
				container[index].attr("transform", "translate(" + (width / 2) + ","
						+ (height / 2) + ")scale(" + zoom.scale() + ")");
			}

			nodes[index] = tree[index].nodes(root);
			links[index] = tree[index].links(nodes[index]);

			nodes[index].forEach(function(d) {
				if (d.depth > 1) {
					if (d.children) {
						d._children = d.children;
						d.children = null;
					}
				}
			});

			root.x0 = 0;
			root.y0 = 0;
			drawTree(root,type,index);
		}

		// 渲染树结构
		function drawTree(data, type, index) {
			nodes[index] = tree[index].nodes(rootData[index]);
			links[index] = tree[index].links(nodes[index]);

			nodes[index].forEach(function(d) {
				if (d.depth > 2) {
					d.y = d.depth * (d.depth / 2) * 150;
				} else {
					d.y = d.depth * 150;
				}
			});
			var maxDepth = 1;
			for (var i = 0; i < nodes[index].length; i++) {
				if (nodes[index][i].depth > maxDepth) {
					maxDepth = nodes[index][i].depth;
				}
			}

			var linkUpdate = linkContainer[index].selectAll(".link").data(links[index],
					function(d) {
						return d.target.id;
					});
			var linkEnter = linkUpdate.enter();
			var linkExit = linkUpdate.exit();
		
			linkEnter.append("path").attr("class", "link").attr("style", "fill:none;stroke-opacity:1;stroke-width:1.5px;").attr("d",
					function(d) {
						var o = {
							x : data.x0,
							y : data.y0
						};
						return diagonal[index]({
							source : o,
							target : o
						});
					}).transition().duration(500).attr("d", diagonal[index]);

			linkUpdate.attr("stroke", function(d) {
				// 高管信息
				if (d.source.Category == "executive" || d.target.Category == "executive") {
					return "#6e94d2";
				}
				// 分支机构
				if (d.source.Category == "branch" || d.target.Category == "branch") {
					return "#ffab13";
				}
				// 法院判决
				if (d.source.Category == "courtOrder" || d.target.Category == "courtOrder") {
					return "#888888";
				}
				// 股东信息
				if (d.source.Category == "shareholder" || d.target.Category == "shareholder") {
					return "#1caf9a";
				}
				// 对外投资
				if (d.source.Category == "fdi" || d.target.Category == "fdi") {
					return "#ff7070";
				}

				return "black";
			}).transition().duration(500).attr("d", diagonal[index]);

			linkExit.transition().duration(500).attr("d", function(d) {
				var o = {
					x : data.x,
					y : data.y
				};
				return diagonal[index]({
					source : o,
					target : o
				});
			}).remove();

			var nodeUpdate = container[index].selectAll(".node").data(nodes[index],
					function(d) {
						return d.id;
					});
			var nodeEnter = nodeUpdate.enter();
			var nodeExit = nodeUpdate.exit();

			var enterNodes = nodeEnter.append("g").attr("class", function(d) {
				return "node";
			}).attr("transform", function(d) {
				return "translate(" + project(data.x0, data.y0) + ")";
			});
			enterNodes.append("circle").attr("r", 0).attr("fill", function(d) {

				// 高管信息
				if (d.Category == "executive") {
					return "#6e94d2";
				}
				// 分支机构
				if (d.Category == "branch") {
					return "#ffab13";
				}
				// 法院判决
				if (d.Category == "courtOrder") {
					return "#888888";
				}
				// 股东信息
				if (d.Category == "shareholder") {
					return "#1caf9a";
				}
				// 对外投资
				if (d.Category == "fdi") {
					return "#ff7070";
				}
				return "#f3523e";
			}).attr("stroke", function(d) {

				if (d.depth == 0) {
					return "#f3523e";
				}

				if (d.depth == 1 || d.depth == 2 || d.depth == 3 || d.depth == 4) {
					// 高管信息
					if (d.Category == "executive") {
						return "#6e94d2";
					}
					// 分支机构
					if (d.Category == "branch") {
						return "#ffab13";
					}
					// 法院判决
					if (d.Category == "courtOrder") {
						return "#888888";
					}
					// 股东信息
					if (d.Category == "shareholder") {
						return "#1caf9a";
					}
					// 对外投资
					if (d.Category == "fdi") {
						return "#ff7070";
					}
				}

				return null;
			}).attr("stroke-opacity", 0.5).attr("stroke-width", function(d) {
				if (d.depth == 0) {
					return 10;
				}

				if (d.depth == 1) {
					return 6;
				}

				return 0;
			}).on("click", function(d) {
				if (d.depth > 0) {
					toggle(d);
					drawTree(d,2,index);
				}
			});

			enterNodes.append("path").attr("d", function(d) {
				if (d.depth > 0 && d._children) {
					return "M-6 -1 H-1 V-6 H1 V-1 H6 V1 H1 V6 H-1 V1 H-6 Z"
				} else if (d.depth > 0 && d.children) {
					return "M-6 -1 H6 V1 H-6 Z"
				}
			}).attr("fill", "#ffffff").attr("stroke", "#ffffff").attr(
					"stroke-width", "0.2").on("click", function(d) {
				if (d.depth > 0) {
					toggle(d);
					drawTree(d,2,index);
				}
			});
			enterNodes.append("text").attr("dy", function(d) {
				if (d.depth == 0) {
					return "-1.5em";
				}
				return "0.31em";
			}).attr("x", function(d) {
				if (d.depth == 0) {
					return d.name.length * 8
				}
				return d.x < 180 ? 35 : -15;
			}).text(function(d) {
				return d.name;
			}).style("text-anchor", function(d) {
				if (d.depth == 0) {
					return "end";
				}
				return d.x < 180 ? "start" : "end";
			}).style("fill-opacity", 0).attr("transform", function(d) {
				if (d.depth > 0) {
					return "rotate(" + (d.x < 180 ? d.x - 110 : d.x + 70) + ")";
				} else {
					return "rotate(0)";
				}
			}).style("font-size", function(d) {
				if (d.depth == 0) {
					return "16px";
				}
				return "14px";
			}).attr("fill", function(d) {
				if (d.depth == 0) {
					return "#f3523e";
				}
				if (d.depth == 1) {
					// 高管信息
					if (d.Category == "executive") {
						 if (type == 1) {
						     gaoguanData[index] = d;
						 }
						 return "#6e94d2";
					}
					// 分支机构
					if (d.Category == "branch") {
						if (type == 1) {
							fenzhiData[index] = d; 
						}
						return "#ffab13";
					}
					// 法院判决
					if (d.Category == "courtOrder") {
						if (type == 1) {
							fayuanData[index] = d; 
						}
						return "#888888";
					}
					// 股东信息
					if (d.Category == "shareholder") {
						if (type == 1) {
							gudongData[index] = d;
						}
						return "#1caf9a";
					}
					// 对外投资
					if (d.Category == "fdi") {
						if (type == 1) {
							touziData[index] = d; 
						}
						return "#ff7070";
					}
				}
				return "red";
			}).on("click", function(d) {
				
				// courtOrder,法院判决
				if (d.Category == 'courtOrder' && d.depth == 2) {
					closeDetail('gsInfoWindow');
					showFyDetail(d);
				} 
				else if (d.isEnterprise){
					closeDetail('infoWindow');
					showGsDetail(d);
				}
				
			});

			enterNodes.append("image").attr("dy", function(d) {
				if (d.depth == 0) {
					return "-1.5em";
				}
				return "0.31em";
			}).attr("x", function(d) {
				return d.x < 180 ? 12 : - d.name.length * 12 * 2;
			}).attr("width", function(d) {
				if (d.Category == "fdi" || d.Category == "executive" || d.Category == "branch" ||  d.Category == "shareholder") {
					return 20;
				}
			}).attr("height", function(d) {
				if (d.Category == "fdi" || d.Category == "executive" || d.Category == "branch" ||  d.Category == "shareholder") {
					return 20;
				}
			}).attr("y", function(d) {
				return -15;
			}).style("text-anchor", function(d) {
				if (d.depth == 0) {
					return "end";
				}
				return d.x < 180 ? "start" : "end";
			}).style("fill-opacity", 0).attr("transform", function(d) {
				if (d.depth > 0) {
					return "rotate(" + (d.x < 180 ? d.x - 110 : d.x + 70) + ")";
				} else {
					return "rotate(0)";
				}
			}).style("font-size", function(d) {
				if (d.depth == 0) {
					return "16px";
				}
				return "14px";
			}).attr("href", function(d) {
				if (d.isEnterprise != undefined) {
					// 高管信息
					if (d.Category == "executive") {
						if (d.isEnterprise) {
							return ctx + "/app/images/creditCubic/bfaren.png";
						} else {
							return ctx + "/app/images/creditCubic/bziranren.png";
						}
					}
					// 分支机构
					if (d.Category == "branch") {
						if (d.isEnterprise) {
							return ctx + "/app/images/creditCubic/yfaren.png";
						} else {
							return ctx + "/app/images/creditCubic/yziranren.png";
						}
					}
					// 股东信息
					if (d.Category == "shareholder") {
						if (d.isEnterprise) {
							return ctx + "/app/images/creditCubic/faren.png";
						} else {
							return ctx + "/app/images/creditCubic/ziranren.png";
						}
					}
					// 对外投资
					if (d.Category == "fdi") {
						if (d.isEnterprise) {
							return ctx + "/app/images/creditCubic/redfaren.png";
						} else {
							return ctx + "/app/images/creditCubic/redziranren.png";
						}
					}
				}
			});
			
			
			var updateNodes = nodeUpdate.transition().duration(500).attr(
					"transform", function(d) {
						return "translate(" + project(d.x, d.y) + ")";
					});
			updateNodes.select("text").style("fill-opacity", 1).attr(
					"transform",
					function(d) {
						if (d.depth > 0) {
							return "rotate("
									+ (d.x < 180 ? d.x - 110 : d.x + 70) + ")";
						} else {
							return "rotate(0)";
						}
					}).attr("x", function(d) {
				if (d.depth == 0) {
					return d.name.length * 8
				}
				return d.x < 180 ? 35 : -35;
			}).attr("fill", function(d) {
				if (d.depth == 0) {
					return "#f3523e";
				}
				if (d.depth == 1 || d.depth == 2 || d.depth == 3 || d.depth == 4) {
					// 高管信息
					if (d.Category == "executive") {
						return "#6e94d2";
					}
					// 分支机构
					if (d.Category == "branch") {
						return "#ffab13";
					}
					// 法院判决
					if (d.Category == "courtOrder") {
						return "#888888";
					}
					// 股东信息
					if (d.Category == "shareholder") {
						return "#1caf9a";
					}
					// 对外投资
					if (d.Category == "fdi") {
						return "#ff7070";
					}
				}
				return "#333";
			}).style("text-anchor", function(d) {
				if (d.depth == 0) {
					return "end";
				}
				return d.x < 180 ? "start" : "end";
			});
			
			updateNodes.select("image").style("fill-opacity", 1).attr(
					"transform",
					function(d) {
						if (d.depth > 0) {
							return "rotate("
									+ (d.x < 180 ? d.x - 110 : d.x + 70) + ")";
						} else {
							return "rotate(0)";
						}
					}).attr("x", function(d) {
				if (d.depth == 0) {
					return d.name.length * 8
				}
				return d.x < 180 ? 12 : -30;
			}).attr("width", function(d) {
				if ((d.Category == "fdi" || d.Category == "executive" || d.Category == "branch" ||  d.Category == "shareholder") && d.depth != 1) {
					return 20;
				} 
			}).attr("height", function(d) {
				if ((d.Category == "fdi" || d.Category == "executive" || d.Category == "branch" ||  d.Category == "shareholder") && d.depth != 1) {
					return 20;
				}
			});
			
			updateNodes.select("circle").attr("r", function(d) {
				if (d.depth == 0) {
					return 12;
				}

				if (d.depth == 1) {
					return 10;
				}

				return 9;
			});
			updateNodes.select("path").attr("d", function(d) {
				if (d.depth > 0 && d._children) {
					return "M-6 -1 H-1 V-6 H1 V-1 H6 V1 H1 V6 H-1 V1 H-6 Z"
				} else if (d.depth > 0 && d.children) {
					return "M-6 -1 H6 V1 H-6 Z"
				}
			});

			var exitNodes = nodeExit.transition().duration(500).attr(
					"transform", function(d) {
						return "translate(" + project(data.x, data.y) + ")";
					}).remove();
			exitNodes.select("circle").attr("r", 0);

			exitNodes.select("text").style("fill-opacity", 0);

			nodes[index].forEach(function(d) {
				d.x0 = d.x;
				d.y0 = d.y;
			});

		}

		function toggle(d) {
			if (d.children) {
				d._children = d.children;
				d.children = null;
			} else {
				d.children = d._children;
				d._children = null;
			}
		}

		function project(x, y) {
			var angle = (x - 90) / 180 * Math.PI, radius = y;
			return [ radius * Math.cos(angle), radius * Math.sin(angle) ];
		}

		// 处理成树数据
		function traverseTreeId(node) {
			if (!node.id) {
				node.id = id;
				id++;
			}
            
			if (node.children) {
				for (var i = 0; i < node.children.length; i++) {
					traverseTreeId(node.children[i]);
				}
			}
		}

		function traverseLevel(node, level, type) {
			if (node.depth <= level) {
				if (node.Category == type) {
					if (node._children) {
						node.children = node._children;
						node._children = null;
					}
				}
			} else {
				if (node.Category == type) {
					if (node.children) {
						node._children = node.children;
						node.children = null;
					}
				}
			}

			if (node.children) {
				for (var i = 0; i < node.children.length; i++) {
					traverseLevel(node.children[i], level, type);
				}
			}

			if (node._children) {
				for (var i = 0; i < node._children.length; i++) {
					traverseLevel(node._children[i], level, type);
				}
			}
		}

		// 打开主体是公司的详细信息
		function showGsDetail(d) {
			var GsDetailStr = '<div class="infoWindow" id="gsInfoWindow">' +
						           '<div class="info-top">' +  
						               '<div>' +  
						                   '<span style="font-size:14px">' + (d.name||"") + '</span><div>' + (d.zl||"") + "</div>" +
						               '</div>' +  
						               '<img src="http://webapi.amap.com/images/close2.gif" onclick="creditAtlas.closeDetail(\'gsInfoWindow\');">' +  
						           '</div>' +  
						           '<div class="info-middle">' + 
								         '<span class="infoWinItem">法定代表人：' + (d.fddbrxm||"") + '</span>' +  
										 '<span class="infoWinItem">注册资本：' + (d.zczj||"") + '万</span>' +  
										 '<span class="infoWinItem">成立时间：' + (d.fzrq||"") + '</span>' +  
										 '<span class="infoWinItem">行业类型：' + (d.sshymc||"") + '</span>' +  
										 '<span class="infoWinItem">通讯地址：' + (d.jgdz||"") + '</span><br/>' +  
										 '<div class=\'infoWinBtn\'><button class=\'btn btn-info btn-md\' onclick="creditAtlas.openWin(\'' + d.qyid + '\', 1)">社会法人</button>  <button  class=\'btn btn-info btn-md\' onclick="creditAtlas.openWin(\'' + d.qyid + '\', 2)">信用图谱</button></div>' +  
						           '</div>' +  
						           '<div class="info-bottom" style="position: relative; top: 0px; margin: 0px auto;">' +  
						           '</div>' +
                               '</div>';
            $("#floatWin").html(GsDetailStr);
		}

		// 打开新页面
		function openWin(id, type){
			if (type == 1) {
				window.open(ctx + "/center/socialLegalPerson/toView.action?isOpen=1&id=" + id);
			} else {
		        getData(id,index);
			}
		}
		 
		// 关闭详细
		function closeDetail(id){
		    $("#" + id).hide();
		}
		
		// 打开法院判决详细信息
		function showFyDetail(d) {
			var FyDetailStr = '<div class="infoWindow" id="infoWindow">' +
		                          '<div class="info-top" style="border:none">' +  
	                                  '<img src="http://webapi.amap.com/images/close2.gif" onclick="creditAtlas.closeDetail(\'infoWindow\');">' +  
	                              '</div>' +  
	                              '<div class="info-middle">' + 
							          '<span class="infoWinItem">案号：' + (d.name||"") + '</span>' +  
									  '<span class="infoWinItem">被执行人名称：' + (d.bzxrmc||"") + '</span>' +  
									  '<span class="infoWinItem">立案时间：' + (d.lasj||"") + '</span>' +  
									  '<span class="infoWinItem">执行标的：' + (d.zxbd||"") + '</span>' +  
									  '<span class="infoWinItem">案件状态：' + (d.ajzt||"") + '</span>' +  
									  '<span class="infoWinItem">执行法院：' + (d.zxfy||"") + '</span>' +  
	                              '</div>' +  
	                              '<div class="info-bottom" style="position: relative; top: 0px; margin: 0px auto;">' +  
	                              '</div>' +
	                          '</div>';
		    $("#floatFyWin").html(FyDetailStr);
		}
		
		function exportImage(){
			   var serializer = new XMLSerializer();  
			   var tabIndex =  parseInt($("#tabs li.active a").attr("id").split("activeA")[1]);
			   var name = $("#activeA" + tabIndex + " span").html();
			   var svg = d3.select("#svg" + tabIndex);
		       var source = serializer.serializeToString(svg.node());  
		      
		       $.post(ctx + "/center/creditCubic/exportImage.action", {name : name, svg:source},
						function(data) {
		    	   			window.location =  ctx + "/center/creditCubic/viewImg.action?path="+encodeURI(data.filePath);
						}, "json");
		       
			//   window.location =  ctx + "/center/creditCubic/exportImage.action?name="+name+"&svg=" + source;
		 }
		
		function uniencode(text)
		{
		    text = escape(text.toString()).replace(/\+/g, "%2B");
		    var matches = text.match(/(%([0-9A-F]{2}))/gi);
		    if (matches)
		    {
		        for (var matchid = 0; matchid < matches.length; matchid++)
		        {
		            var code = matches[matchid].substring(1,3);
		            if (parseInt(code, 16) >= 128)
		            {
		                text = text.replace(matches[matchid], '%u00' + code);
		            }
		        }
		    }
		    text = text.replace('%25', '%u0025');
		 
		    return text;
		} 
		
		// 股东或投资层级下拉框改变值时，对应的树状也会显示或隐藏对应的层级
		function selectChange(obj, type) {
			var tabIndex =  parseInt($("#tabs li.active a").attr("id").split("activeA")[1]);
			// 对外投资层级
			if (type == 1) {
				touzilevel[tabIndex] = $(obj).val();
				traverseLevel(rootData[tabIndex], touzilevel[tabIndex], 'fdi');
				drawTree(rootData[tabIndex], 2, tabIndex);
			} else {
			// 股东层级
				gudongLevel[tabIndex] = $(obj).val();
				traverseLevel(rootData[tabIndex], gudongLevel[tabIndex], 'shareholder');
				drawTree(rootData[tabIndex], 2, tabIndex);
			}
		}
		
		// 点击图例显示或隐藏对应的树形分支
		function showhideTree(obj){
			var legType = obj.value;
			var ck_status = obj.checked;
			var tabIndex =  parseInt($("#tabs li.active a").attr("id").split("activeA")[1]);
			var legendIndex = $("input[name='legend']").index($(obj));
			legendCkStatus[tabIndex][legendIndex] = ck_status;
			
			if ($("input[name='legend']:checked").length == 1) {
				$("input[name='legend']:checked").each(function(){
					$(this).attr('disabled',true);
				})
			} else {
				$("input[name='legend']:checked").each(function(){
					$(this).attr('disabled',false);
				})
			}
		
			switch(legType) {
			    // 股东信息
				case 'gd':
					toggleLed(gudongData[tabIndex],ck_status,3,tabIndex);
					break;
				// 高管信息
				case 'gg':
					toggleLed(gaoguanData[tabIndex],ck_status,0,tabIndex);
					break;
				// 法院判决
				case 'fy':
					toggleLed(fayuanData[tabIndex],ck_status,2,tabIndex);
					break;
				// 对外投资
				case 'tz':
					toggleLed(touziData[tabIndex],ck_status,4,tabIndex);
					break;
				// 默认  分支机构
				default:
					toggleLed(fenzhiData[tabIndex],ck_status,1,tabIndex);
					break;
			}
		}
		
		// 显示或删除对应的数据
		function toggleLed(d, status, i,tabIndex) {
				if (status) {
					rootData[tabIndex].children.push(d);
				} else {
					rootData[tabIndex].children.remove(d);
				}
				drawTree(d, 2, tabIndex);
		}
		
		// 切换Tab
		function  switchTabs(tabIndex) {
			 closeDetail('gsInfoWindow');
			 closeDetail('infoWindow');
			 $("input[name='legend']").each(function(i,obj){
				  $(this).attr("checked",legendCkStatus[tabIndex][i]);
			 }); 
			 
			 $("#touziSelect").val(touzilevel[tabIndex]);
			 
			 $("#gudongSelect").val(gudongLevel[tabIndex]);
			 
			 if ($("input[name='legend']:checked").length == 1) {
				  $("input[name='legend']:checked").each(function(){
						$(this).attr('disabled',true);
				  });
				  $("input[name='legend']").not("input:checked").each(function(){
					  $(this).attr('disabled',false);
			      });
			} else {
				 $("input[name='legend']").each(function(){
					  $(this).attr('disabled',false);
			     });
			}
		}
		
		function btnSearch(){
			if($.trim($searchInput.val()) != "") {
			       ajax_request();
	        }
		}
		
		function conditionSearch(){
			loading();
			var id = null;
			var qyid = $.trim($("#search-text").attr("qyid"));
			for (var i = 0;i < suitResults.length;i++) {
				if (suitResults[i].ID == qyid) {
					id = suitResults[i].ID;
				}
			}
			if (id) {
			    getData(id,index);
			} else {
				$.alert('暂未查询到数据!');
			}
			loadClose();
		}
		 
		// 关闭Tab
		function closeTab(obj, id){
			
			if ($("#tabs li").length == 1) {
			    $("#tabbable").hide();
			    $("#defaultBg").show();
			}
			
			$(obj).parent().parent().remove();
			$("#" + id).remove();
		
			$("#tabs li:first a").trigger("click");
			
			var liWidths = 0;
			$("#tabs li").each(function(){
				 liWidths += parseInt($(this).width());
			});
			
			liWidths += 100;
		    //$(".nav-tabs").width(liWidths + "px");  
		    
		    if (liWidths <= parseInt($("#tabs .tab-content").width())) {
				 $(".tabs-scroller").hide();
				 $("#tabbable ul").animate({left: 0 + "px"}, 500);
			} 
		    
		}
		
		var index= 0;
		// 新增Tab
		function addTab(name){
		  if ($("#tabbable").css("display") == "none") {
			  $("#tabbable").show();
		  }
		  if ($("#defaultBg").css("display") == "block") {
			  $("#defaultBg").hide();
		  }
		  var liStr = '<li><a id="activeA' + index + '" href="#portlet_tab' + index + '" data-toggle="tab" onclick="creditAtlas.switchTabs(' + index + ')"><span>' + name + '</span><img id="img' + index + '" src="http://webapi.amap.com/images/close2.gif" width="8"  class="close-icon" onclick="creditAtlas.closeTab(this,\'portlet_tab' + index + '\')"/></a></li>';
		  var contentStr = '<div class="tab-pane" id="portlet_tab' + index + '"><svg id="svg' + index + '"></svg></div>';
		  $("#tabs ul").append(liStr);
		  $("#tabs .tab-content").append(contentStr);
		  
		  legendCkStatus[index] = [];
		  $("input[name='legend']").each(function(){
			  legendCkStatus[index].push(true);
		  }); 
		  
		  touzilevel[index] = [];
		  gudongLevel[index] = [];
		  
		  touzilevel[index].push(1);
		  
		  gudongLevel[index].push(1);
			 
		  $("#activeA" + index).trigger("click");
		  
		  // 使用原生js终止事件冒泡
		  var p = document.getElementById("img" + index);
		  p.addEventListener('click',function(e){  
              e.stopPropagation();//终止事件冒泡  
          },false);  
		  index++;
		  
		  var liWidths = 0;
		  $("#tabs li").each(function(){
			  liWidths += parseInt($(this).width());
		  })
		  
		  if (liWidths > parseInt($("#tabs .tab-content").width())) {
			  $(".tabs-scroller").show();
		  } else {
			  $(".tabs-scroller").hide();
		  }
		}
		
		// Tab左右滑动
		function scrollTabs(type) {
			//$(".nav-tabs").
			var leftDis = parseInt($("#tabbable ul").css("left")) ;
			//var rightDis = parseInt($("#tabbable ul").css("right")) ;
			if (type == 1) {
				if ((leftDis + 100) <= 0) {
					leftDis += 100;
				} else if(-leftDis < 100){
					leftDis = 0;
				}
			} else {
				 var liWidths = 0;
				  $("#tabs li").each(function(){
					  liWidths += parseInt($(this).width());
				  })
				  liWidths += 100;
				//var ulWidth = parseInt($("#tabbable ul").width());
				if (liWidths + leftDis > parseInt($("#tabs").width())) {
					leftDis -= 100;
				}
			}
			$("#tabbable ul").animate({left: leftDis + "px"}, 300);
		}
		
	return {
		showhideTree : showhideTree,
		conditionSearch : conditionSearch,
		btnSearch : btnSearch,
		closeTab : closeTab,
		addTab : addTab,
		closeDetail : closeDetail,
		switchTabs : switchTabs,
		selectChange : selectChange,
		scrollTabs : scrollTabs,
		openWin : openWin,
		exportImage : exportImage
	}; 
})();
	