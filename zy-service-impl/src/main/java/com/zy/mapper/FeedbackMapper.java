package com.zy.mapper;


import java.util.List;
import org.apache.ibatis.annotations.Param;

import com.zy.entity.cms.Feedback;
import com.zy.model.query.FeedbackQueryModel;


public interface FeedbackMapper {

	int insert(Feedback feedback);

	int update(Feedback feedback);

	int merge(@Param("feedback") Feedback feedback, @Param("fields")String... fields);

	int delete(Long id);

	Feedback findOne(Long id);

	List<Feedback> findAll(FeedbackQueryModel feedbackQueryModel);

	long count(FeedbackQueryModel feedbackQueryModel);

}