package com.zy.mapper;


import java.util.List;
import org.apache.ibatis.annotations.Param;

import com.zy.entity.act.ActivityCollect;
import com.zy.model.query.ActivityCollectQueryModel;


public interface ActivityCollectMapper {

	int insert(ActivityCollect activityCollect);

	int update(ActivityCollect activityCollect);

	int merge(@Param("activityCollect") ActivityCollect activityCollect, @Param("fields")String... fields);

	int delete(Long id);

	ActivityCollect findOne(Long id);

	List<ActivityCollect> findAll(ActivityCollectQueryModel activityCollectQueryModel);

	long count(ActivityCollectQueryModel activityCollectQueryModel);

	ActivityCollect findByActivityIdAndUserId(@Param("activityId") Long activityId, @Param("userId") Long userId);

}