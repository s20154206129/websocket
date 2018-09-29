package org.xdemo.example.websocket.service;

import java.util.List;

import org.xdemo.example.websocket.entity.Message;

public interface MessageService {
	public List<Message> getMessageByFromId(int from);

	public List<Message> getMessageByToId(int to);

	public List<Message> getMessageUnReceive(int to);

	public List<Message> getMessageByType(int type);

	public void addMessage(Message message);

	public int deleteMessage(Message message);

	public int updateMessage(Message message);
}
