package org.xdemo.example.websocket.serviceimpl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.xdemo.example.websocket.dao.MessageDao;
import org.xdemo.example.websocket.entity.Message;
import org.xdemo.example.websocket.service.MessageService;

@Service("messageService")
public class MessageServiceImplement implements MessageService {

	@Autowired
	private MessageDao messageDao;
	
	@Override
	public List<Message> getMessageByFromId(int from) {
		return messageDao.getMessageByFromId(from);
	}

	@Override
	public List<Message> getMessageByToId(int to) {
		return messageDao.getMessageByToId(to);
	}
	
	@Override
	public List<Message> getMessageUnReceive(int to) {
		return (List<Message>)messageDao.getMessageUnReceive(to);
	}

	@Override
	public List<Message> getMessageByType(int type) {
		return messageDao.getMessageByType(type);
	}

	@Override
	public void addMessage(Message message) {
		messageDao.addMessage(message);

	}

	@Override
	public int  deleteMessage(Message message) {
		return messageDao.deleteMessage(message);
	}

	@Override
	public int  updateMessage(Message message) {
		return messageDao.updateMessage(message);
	}

}
