// 中心端主页
var indexCenter = function () {

    var myChart1 = echarts.init(document.getElementById("topicCountBar"));//业务量统计柱状图
    var myChart2 = echarts.init(document.getElementById("sgsPie"));//专题统计双公示环状图
    var myChart3 = echarts.init(document.getElementById("mingdanPie"));//专题统计红黑名单环状图
    var myChart4 = echarts.init(document.getElementById("creditCommintPie"));//专题统计信用承诺环状图

    /*初始化柱状图*/
    function initBar(yuefeng,shangbaoCount,rukuCount,yiwenCount, updateCount) {
        myChart1.clear();
        myChart1.setOption({
            color: ['#578EBE', '#44B6AE', '#df5444'],
            tooltip: {
                trigger: 'axis',
                axisPointer: {
                    type: 'shadow'
                }
            },
            legend: {
                data: ['上报量', '入库量', '更新量', '疑问量']
            },
            calculable: false,
            xAxis: [
                {
                    type: 'category',
                    axisTick: {show: false},
                    data: yuefeng
                }
            ],
            yAxis: [
                {
                    type: 'value',
                    splitArea: { show: true },
                    show: true,
                    axisLabel : {
                        formatter : function(val) {
                            if(val >= 10000){//当纵轴刻度数字超过4位数时，如355000，则显示35.5万；
                                val = val/10000+'万'
                            }

                            return val+"条";
                        }
                    }
                }
            ],
            series: [
                {
                    name: '上报量',
                    type: 'bar',
                    data: shangbaoCount
                },
                {
                    name: '入库量',
                    type: 'bar',
                    data: rukuCount
                },
                {
                    name: '更新量',
                    type: 'bar',
                    data: updateCount
                },
                {
                    name: '疑问量',
                    type: 'bar',
                    data: yiwenCount
                }
            ],
            // dataZoom: [ //滚动轴
            //     {
            //         show: true,
            //         height: 40,
            //         type: 'slider',
            //         top: '90%',
            //         right: '10%',
            //         left: '8%',
            //         xAxisIndex: [0],
            //         start: 0,
            //         end: 5
            //     }
            // ],
        });
        myChart1.hideLoading();
        myChart1.resize();
    }
    $(window).resize(function () {
        myChart1.resize();
        myChart2.resize();
        myChart3.resize();
        myChart4.resize();
    });

    /*初始化环状图*/
    function initPie(chart,dataChart){
        chart.clear();
        var option = {

            color: [ '#df5444','#578EBE'],
            title:{
                text:'',
                subtext:'',
                x:'center'
            },
            tooltip: {
                trigger: 'item',
                formatter: "{d}%"
            },
            series:[
                {
                    name:'',
                    type:'pie',
                    radius:['50%','75%'],
                    avoidLabelOverlap: false,
                    label: {
                        normal: {
                            show: false,
                            position: 'center'
                        },
                        emphasis: {
                            show: true,
                            textStyle: {
                                fontSize: '10',
                                fontWeight: 'bold'
                            }
                        }
                    },
                    data : dataChart
                }
            ]
        }
        chart.setOption(option);
        chart.hideLoading();
        chart.resize();
    }

    //业务量统计
    $.getJSON(ctx + "/center/index/getTrafficCount.action", function (result) {
        $('#ExamineOfApplyEnterprise').text(result.ExamineOfApplyEnterprise);
        $('#ExamineOfApplyPerson').text(result.ExamineOfApplyPerson);
        $('#monthOfApply').text(result.monthOfApply);
        $('#allOfApply').text(result.allOfApply);

        $('#ExamineOfExamineEnterprise').text(result.ExamineOfExamineEnterprise);
        $('#ExamineOfExaminePerson').text(result.ExamineOfExaminePerson);
        $('#monthOfExamine').text(result.monthOfExamine);
        $('#allOfExamine').text(result.allOfExamine);

        $('#repairExamine').text(result.repairExamine);
        $('#repairRepair').text(result.repairRepair);
        $('#monthOfRepair').text(result.monthOfRepair);
        $('#allOfRepair').text(result.allOfRepair);

        $('#objectionExamine').text(result.objectionExamine);
        $('#objectionRepair').text(result.objectionRepair);
        $('#monthOfObjection').text(result.monthOfObjection);
        $('#allOfObjection').text(result.allOfObjection);

    });

    //数据量统计
    $.getJSON(ctx + "/center/index/getDataSizeCount.action", function (result) {
        var yuefeng = [];
        var shangbaoCount = [];
        var rukuCount = [];
        var yiwenCount = [];
        var updateCount = [];

        yuefeng = result.yuefeng;
        shangbaoCount = result.shangbaoCount;
        rukuCount = result.rukuCount;
        yiwenCount = result.yiwenCount;
        updateCount = result.updateCount;

        initBar(yuefeng,shangbaoCount,rukuCount,yiwenCount,updateCount);
    });

    getMonthTopicCount();//默认打开专题统计(本月新增)

    //专题统计(本月新增)
    function getMonthTopicCount() {
        var monthOfChart2 = [];
        var monthOfChart3 = [];
        var monthOfChart4 = [];

        $('#allTopicCount').removeClass();
        $('#monthTopicCount').addClass('countTabAct');
        $.getJSON(ctx + "/center/index/getTopicCount.action", function (result) {
            $('#dataOfsgsxzxk').text(result.monthOfsgsxzxk);
            $('#dataOfsgsxzcf').text(result.monthOfsgsxzcf);

            $('#dataOfhongmingdan').text(result.monthOfhongmingdan);
            $('#dataOfheimingdan').text(result.monthOfheimingdan);

            $('#creditCommint').text(result.monthOfCreditCommint);
            $('#creditCommintWithBlack').text(result.monthOfCreditCommintWithBlack);


            monthOfChart2.push({value:result.monthOfsgsxzxk==null?0:result.monthOfsgsxzxk,name:'双公示行政许可'});
            monthOfChart2.push({value:result.monthOfsgsxzcf==null?0:result.monthOfsgsxzcf,name:'双公示行政处罚'});

            monthOfChart3.push({value:result.monthOfhongmingdan==null?0:result.monthOfhongmingdan,name:'红名单'});
            monthOfChart3.push({value:result.monthOfheimingdan==null?0:result.monthOfheimingdan,name:'黑名单'});

            monthOfChart4.push({value:result.monthOfCreditCommint==null?0:result.monthOfCreditCommint,name:'信用承诺主体'});
            monthOfChart4.push({value:result.monthOfCreditCommintWithBlack==null?0:result.monthOfCreditCommintWithBlack,name:'列入黑名单'});

            if(monthOfChart2[0].value == 0 && monthOfChart2[1].value == 0){
                monthOfChart2 = [{value:0,name:'暂无数据'}];
            }
            if(monthOfChart3[0].value == 0 && monthOfChart3[1].value == 0){
                monthOfChart3 = [{value:0,name:'暂无数据'}];
            }
            if(monthOfChart4[0].value == 0 && monthOfChart4[1].value == 0){
                monthOfChart4 = [{value:0,name:'暂无数据'}];

            }
            initPie(myChart2,monthOfChart2);
            initPie(myChart3,monthOfChart3);
            initPie(myChart4,monthOfChart4);

        });

    };

    //专题统计(累计全部)
    function getAllTopicCount() {
        var allOfChart2 = [];
        var allOfChart3 = [];
        var allOfChart4 = [];

        $('#monthTopicCount').removeClass();
        $('#allTopicCount').addClass('countTabAct');
        $.getJSON(ctx + "/center/index/getTopicCount.action", function (result) {
            $('#dataOfsgsxzxk').text(result.allOfsgsxzxk);
            $('#dataOfsgsxzcf').text(result.allOfsgsxzcf);

            $('#dataOfhongmingdan').text(result.allOfhongmingdan);
            $('#dataOfheimingdan').text(result.allOfheimingdan);

            $('#creditCommint').text(result.allOfCreditCommint);
            $('#creditCommintWithBlack').text(result.allOfCreditCommintWithBlack);

            allOfChart2.push({value:result.allOfsgsxzxk==null?0:result.allOfsgsxzxk,name:'双公示行政许可'});
            allOfChart2.push({value:result.allOfsgsxzcf==null?0:result.allOfsgsxzcf,name:'双公示行政处罚'});

            allOfChart3.push({value:result.allOfhongmingdan==null?0:result.allOfhongmingdan,name:'红名单'});
            allOfChart3.push({value:result.allOfheimingdan==null?0:result.allOfheimingdan,name:'黑名单'});

            allOfChart4.push({value:result.allOfCreditCommint==null?0:result.allOfCreditCommint,name:'信用承诺主体'});
            allOfChart4.push({value:result.allOfCreditCommintWithBlack==null?0:result.allOfCreditCommintWithBlack,name:'列入黑名单'});

            if(allOfChart2[0].value == 0 && allOfChart2[1].value == 0){
                allOfChart2 = [{value:0,name:'暂无数据'}];
            }
            if(allOfChart3[0].value == 0 && allOfChart3[1].value == 0){
                allOfChart3 = [{value:0,name:'暂无数据'}];
            }
            if(allOfChart4[0].value == 0 && allOfChart4[1].value == 0){
                allOfChart4 = [{value:0,name:'暂无数据'}];
            }

            initPie(myChart2,allOfChart2);
            initPie(myChart3,allOfChart3);
            initPie(myChart4,allOfChart4);

        });

    };

    //联合奖惩统计
    $.getJSON(ctx + "/center/index/getUniteCount.action", function (result) {
        $('#rewardsCount').text(result.rewardsCount);
        $('#personRewards').text(result.personRewards);
        $('#enterpriseRewards').text(result.enterpriseRewards);

        $('#punishmentCount').text(result.punishmentCount);
        $('#personPunishment').text(result.personPunishment);
        $('#enterprisePunishment').text(result.enterprisePunishment);

        $('#personFeedback').text(result.personFeedback);
        $('#enterpriseFeedback').text(result.enterpriseFeedback);

    });

    //数据征集统计
    $.getJSON(ctx + "/center/index/getCollectCount.action", function (result) {
        $('#allCreditCount').text(result.allCreditCount);
        $('#allEnterpriseCount').text(result.allEnterpriseCount);
        $('#allPersonCount').text(result.allPersonCount);
    });

    //跳转法人信用审核页面
    function toCreditExamineList(){
        AccordionMenu.openUrl('法人信用审查审核',ctx +'/center/creditCheck/toCreditExamineList.action')
    }

    return {
        "getMonthTopicCount": getMonthTopicCount,
        "getAllTopicCount": getAllTopicCount,
        "toCreditExamineList":toCreditExamineList

}
}();