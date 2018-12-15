package com.wa.framework.utils;

import org.apache.commons.lang3.time.DateFormatUtils;

import java.util.Calendar;
import java.util.Date;

/**
 * @author beijh
 * @date 2018-11-29 15:46
 */
public class DateUtils {

        public static final String YYYYMMDD_8 = "yyyyMMdd";
        public static final String YYYYMMDD_10 = "yyyy-MM-dd";
        public static final String YYYYMMDDHHMM_12 = "yyyyMMddHHmm";
        public static final String YYYYMMDDHHMM_16 = "yyyy-MM-dd HH:mm";
        public static final String YYYYMMDDHHMMSS_19 = "yyyy-MM-dd HH:mm:ss";
        public static final String YYYYMMDDHHMMSSSSS_17 = "yyyyMMddHHmmssSSS";
        public static final String DEFAULT_PATTERN = "yyyy-MM-dd HH:mm:ss";

        public DateUtils() {
        }

        public static String format(Date date) {
            return format(date, "yyyy-MM-dd HH:mm:ss");
        }

        public static String format(long millis) {
            return format(millis, "yyyy-MM-dd HH:mm:ss");
        }

        public static String format(Calendar calendar) {
            return format(calendar, "yyyy-MM-dd HH:mm:ss");
        }

        public static String format(Date date, String pattern) {
            return DateFormatUtils.format(date, pattern);
        }

        public static String format(long millis, String pattern) {
            return DateFormatUtils.format(millis, pattern);
        }

        public static String format(Calendar calendar, String pattern) {
            return DateFormatUtils.format(calendar, pattern);
        }

        public static Date parseDate(String strDate) {
            return parseDate(strDate, "yyyy-MM-dd HH:mm:ss");
        }

        public static Date parseDate(String strDate, String pattern) {
            Date result = null;

            try {
                result = org.apache.commons.lang3.time.DateUtils.parseDate(strDate, new String[]{pattern});
                return result;
            } catch (Exception var4) {
                throw new RuntimeException(var4.getMessage(), var4);
            }
        }

        public static int compareYear(Date dateOne, Date dateTwo) {
            return compareField(dateOne, dateTwo, 1);
        }

        public static int compareYearToMonth(Date dateOne, Date dateTwo) {
            int result = compareField(dateOne, dateTwo, 1);
            return result != 0 ? result : compareField(dateOne, dateTwo, 2);
        }

        public static int compareYearToDay(Date dateOne, Date dateTwo) {
            int result = compareField(dateOne, dateTwo, 1);
            return result != 0 ? result : compareField(dateOne, dateTwo, 6);
        }

        public static int compareYearToHour(Date dateOne, Date dateTwo) {
            int result = compareField(dateOne, dateTwo, 1);
            if (result != 0) {
                return result;
            } else {
                result = compareField(dateOne, dateTwo, 6);
                return result != 0 ? result : compareField(dateOne, dateTwo, 11);
            }
        }

        public static int compareYearToMinutes(Date dateOne, Date dateTwo) {
            int result = compareField(dateOne, dateTwo, 1);
            if (result != 0) {
                return result;
            } else {
                result = compareField(dateOne, dateTwo, 6);
                if (result != 0) {
                    return result;
                } else {
                    result = compareField(dateOne, dateTwo, 11);
                    return result != 0 ? result : compareField(dateOne, dateTwo, 12);
                }
            }
        }

        public static int compareYearToSeconds(Date dateOne, Date dateTwo) {
            int result = compareField(dateOne, dateTwo, 1);
            if (result != 0) {
                return result;
            } else {
                result = compareField(dateOne, dateTwo, 6);
                if (result != 0) {
                    return result;
                } else {
                    result = compareField(dateOne, dateTwo, 11);
                    if (result != 0) {
                        return result;
                    } else {
                        result = compareField(dateOne, dateTwo, 12);
                        return result != 0 ? result : compareField(dateOne, dateTwo, 13);
                    }
                }
            }
        }

        public static int compareDate(Date dateOne, Date dateTwo) {
            if (dateOne == null) {
                throw new IllegalArgumentException("The dateOne must not be null");
            } else if (dateTwo == null) {
                throw new IllegalArgumentException("The dateTwo must not be null");
            } else {
                long result = dateOne.getTime() - dateTwo.getTime();
                if (result > 0L) {
                    return 1;
                } else {
                    return result < 0L ? -1 : 0;
                }
            }
        }

        private static int compareField(Date dateOne, Date dateTwo, int calendarField) {
            if (dateOne == null) {
                throw new IllegalArgumentException("The dateOne must not be null");
            } else if (dateTwo == null) {
                throw new IllegalArgumentException("The dateTwo must not be null");
            } else {
                Calendar compareCalendarOne = Calendar.getInstance();
                compareCalendarOne.setTime(dateOne);
                Calendar compareCalendarTwo = Calendar.getInstance();
                compareCalendarTwo.setTime(dateTwo);
                int result = compareCalendarOne.get(calendarField) - compareCalendarTwo.get(calendarField);
                if (result > 0) {
                    return 1;
                } else {
                    return result < 0 ? -1 : 0;
                }
            }
        }

        public static Date addYears(Date date, int amount) {
            return add(date, 1, amount);
        }

        public static Date addMonths(Date date, int amount) {
            return add(date, 2, amount);
        }

        public static Date addWeeks(Date date, int amount) {
            return add(date, 3, amount);
        }

        public static Date addDays(Date date, int amount) {
            return add(date, 5, amount);
        }

        public static Date addHours(Date date, int amount) {
            return add(date, 11, amount);
        }

        public static Date addMinutes(Date date, int amount) {
            return add(date, 12, amount);
        }

        public static Date addSeconds(Date date, int amount) {
            return add(date, 13, amount);
        }

        public static Date addMilliseconds(Date date, int amount) {
            return add(date, 14, amount);
        }

        private static Date add(Date date, int calendarField, int amount) {
            if (date == null) {
                throw new IllegalArgumentException("The date must not be null");
            } else {
                Calendar c = Calendar.getInstance();
                c.setTime(date);
                c.add(calendarField, amount);
                return c.getTime();
            }
        }

        public static boolean checkBetween(Date startTime, Date endTime, Date toJudgeTime) {
            return startTime.before(toJudgeTime) && endTime.after(toJudgeTime);
        }

        public static boolean checkOverlapped(Date start1, Date end1, Date start2, Date end2) {
            if (start1.before(end1) && start2.before(end2)) {
                return end1.after(start2) && start1.before(end2);
            } else {
                throw new IllegalArgumentException("arguments error: argument start1 must before argument end1 or argument start2 must before argument end2");
            }
        }

        public static long calculateDiffDays(Date date1, Date date2) {
            long diff = date1.getTime() - date2.getTime();
            long days = diff % 86400000L == 0L ? diff / 86400000L : diff / 86400000L + 1L;
            return days;
        }

        public static String getYear() {
            return get(getNow(), 1);
        }

        public static Date getNow() {
            return new Date();
        }

        public static String get(Date date, int type) {
            Calendar c = Calendar.getInstance();
            c.setTime(date);
            int t = c.get(type);
            if (type == 2) {
                ++t;
            }

            return t + "";
        }
    }
