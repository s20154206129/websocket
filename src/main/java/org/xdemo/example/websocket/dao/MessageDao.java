package org.xdemo.example.websocket.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.xdemo.example.websocket.entity.Message;

public interface MessageDao {
	public List<Message> getMessageByFromId(@Param("from")int from);

	public List<Message> getMessageByToId(@Param("to")int to);

	public List<Message> getMessageUnReceive(@Param("to")int to);

	public List<Message> getMessageByType(@Param("type")int type);

	public void addMessage(Message message);

	public int  deleteMessage(Message message);

	public int  updateMessage(Message message);
}
