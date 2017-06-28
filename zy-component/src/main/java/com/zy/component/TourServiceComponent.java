package com.zy.component;

import com.zy.entity.tour.Sequence;
import com.zy.service.TourService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.text.SimpleDateFormat;
import java.util.Date;

@Component
public class TourServiceComponent {

	@Autowired
	private TourService tourService;


	/**
	 * 处理生成 旅游编号
	 生成规则：T+YY(两位的年份)+NUM(7位的数字)
	 */
	public String getgetNextTourID(){
      String year = dateToStr(new Date(),"yy");
		String newSeq = this.getNewSeq("seq_tour_num",7,year);
		return  "T"+year+newSeq;
	}


	/**
	 * 查询 新的seq 并格式化成指定格式
	 * @param seqName （seq 的那么）
	 * @param length （格式化  多长）
	 * @param year
     * @return
     */
	private  String getNewSeq( String seqName,int length,String year) {
		String returnStr = "";
		Sequence sequence = tourService.findSequenceOne(seqName,year);
		   if (sequence == null ) {
			returnStr = "1";
			Sequence sequenceIn = new Sequence();
			sequenceIn.setSequenceName(seqName);
			sequenceIn.setSequenceType(year);
			sequenceIn.setCurrentVal(1L);
			sequenceIn.setIncrementval(1);
			tourService.create(sequenceIn);
		} else {
			int oldSeq = sequence.getCurrentVal().intValue();
			int newSeq = oldSeq + 1;
			returnStr=newSeq+"";
			sequence.setCurrentVal(new Long(newSeq));
			tourService.updateSequence(sequence);
		}
		int seqLength =returnStr.length();
		if (seqLength < length) {
			int moreZerolength = length - seqLength;
			String moreZeroStr = "";
			for (int i = 1; i <= moreZerolength; i++) {
				moreZeroStr += "0";
			}
			returnStr = moreZeroStr + returnStr;
		}
		return returnStr;
	}


	/**
	 * 格式化时间 成字符串
	 * @param date
	 * @param format
     * @return
     */
	public static String dateToStr(Date date, String format) {
		if (null == date) {
			return "";
		}
		SimpleDateFormat sdf = new SimpleDateFormat(format);
		return sdf.format(date);
	}

	public static  void main(String []age){
		System.out.print(TourServiceComponent.dateToStr(new Date(),"yy"));

	}
	
	

	
}