package com.udatech.common.util;


import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;


/**
 * 日期日历工具类（获取法定节假日、休息日、周末天数）
 * @author Administrator
 *
 */


public class ChineseCalendarUtils {

// 法律规定的放假日期
    private List<String> lawHolidays = Arrays.asList("2017-12-30","2017-12-31",
    "2018-01-01","2018-02-15","2018-02-16","2018-02-17","2018-02-18",
    "2018-02-19","2018-02-20","2018-02-21","2018-04-05","2018-04-06",
    "2018-04-07","2018-04-29","2018-04-30","2018-05-01","2018-06-16",
    "2018-06-17","2018-06-18","2018-09-22","2018-09-23","2018-09-24",
    "2018-10-01","2018-10-02","2018-10-03","2018-10-04","2018-10-05",
    "2018-10-06","2018-10-07");
    // 由于放假需要额外工作的周末
    private List<String> extraWorkdays =Arrays.asList("2018-02-11","2018-02-24",
    "2018-04-08","2018-04-28","2018-09-29","2018-09-30");


    
    /**
     * 判断是否是法定假日
     * 
     * @param calendar
     * @return
     * @throws Exception
     */
    public boolean isLawHoliday(String calendar) throws Exception {
        this.isMatchDateFormat(calendar);
        if (lawHolidays.contains(calendar)) {
            return true;
        }
        return false;
    }


    /**
     * 判断是否是周末
     * 
     * @param calendar
     * @return
     * @throws ParseException
     */
    public boolean isWeekends(String calendar) throws Exception {
        this.isMatchDateFormat(calendar);
        // 先将字符串类型的日期转换为Calendar类型
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Date date = sdf.parse(calendar);
        Calendar ca = Calendar.getInstance();
        ca.setTime(date);
        if (ca.get(Calendar.DAY_OF_WEEK) == 1
                || ca.get(Calendar.DAY_OF_WEEK) == 7) {
            return true;
        }
        return false;
    }


    /**
     * 判断是否是需要额外补班的周末
     * 
     * @param calendar
     * @return
     * @throws Exception
     */
    public boolean isExtraWorkday(String calendar) throws Exception {
        this.isMatchDateFormat(calendar);
        if (extraWorkdays.contains(calendar)) {
            return true;
        }
        return false;
    }


    /**
     * 判断是否是休息日（包含法定节假日和不需要补班的周末）
     * 
     * @param calendar
     * @return
     * @throws Exception
     */
    public boolean isHoliday(String calendar) throws Exception {
        this.isMatchDateFormat(calendar);
        // 首先法定节假日必定是休息日
        if (this.isLawHoliday(calendar)) {
            return true;
        }
        // 排除法定节假日外的非周末必定是工作日
        if (!this.isWeekends(calendar)) {
            return false;
        }
        // 所有周末中只有非补班的才是休息日
        if (this.isExtraWorkday(calendar)) {
            return false;
        }
        return true;
    }




    /**
     * 使用正则表达式匹配日期格式
     * 
     * @throws Exception
     */
    private void isMatchDateFormat(String calendar) throws Exception {
        Pattern pattern = Pattern.compile("\\d{4}-\\d{2}-\\d{2}");
        Matcher matcher = pattern.matcher(calendar);
        boolean flag = matcher.matches();
        if (!flag) {
            throw new Exception("输入日期格式不正确，应该为2017-12-19");
        }
    }

/**
     * 指定日期加上天数后的日期
     * @param num 为增加的天数
     * @param newDate 创建时间
     * @return
     * @throws ParseException 
     */
    public static String plusDay(int num,String newDate) throws ParseException{
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
        Date  currdate = format.parse(newDate);
        Calendar ca = Calendar.getInstance();
        ca.setTime(currdate);
        ca.add(Calendar.DATE, num);// num为增加的天数，可以改变的
        currdate = ca.getTime();
        String enddate = format.format(currdate);
        return enddate;
    }

    
    public static void main(String[] args) throws Exception {

    	
        String calendar = "2018-07-07";
        /*ChineseCalendarUtils cc = new ChineseCalendarUtils();
        System.out.println("是否是法定节假日：" + cc.isLawHoliday(calendar));
        System.out.println("是否是周末：" + cc.isWeekends(calendar));
        System.out.println("是否是需要额外补班的周末：" + cc.isExtraWorkday(calendar));*/
        //System.out.println("是否是休息日：" + cc.isHoliday(calendar)));
        
    	for (int i = 0; i < 500; i++) {
    		ChineseCalendarUtils cc = new ChineseCalendarUtils();
    		String dd = plusDay(i, "2018-01-01");
    		if(dd.equals("2019-01-01"))
    			break;
    		if(cc.isHoliday(dd))
    			System.out.println(dd);
		}
    }
}