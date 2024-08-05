package com.example.demo;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@CrossOrigin
@Controller
public class ChatController {
	
	@Autowired
	private MemberRepository memberRepository;
	
	@Autowired
	private ChatDataRepository chatDataRepository;
	
	@RequestMapping(value="/", method=RequestMethod.GET)
	public String index(HttpServletRequest request) {
		
//		List<SimpleBoardData> result = simpleBoardDAO.findAll(Sort.by(Sort.Direction.DESC, "id"));
//		request.setAttribute("boardList", result);
		
		return "chat";
	}
	
	
	@RequestMapping(value="/login", method=RequestMethod.POST)
	@ResponseBody
	public String login(@RequestBody LoginDto loginDto, 
						
							HttpSession session
						) {
		
		String nickname = loginDto.getNickname();
		System.out.println("받은 닉네임 : " + nickname);
		Long loginCnt = memberRepository.countByNickname(nickname);
		if(loginCnt <=0) {
			return "{\"result\" : \"fail\"}";
		}
		else {
			session.setAttribute("nickname", nickname);
			return "{\"result\" : \"success\"}";
		}
	}
		
	@RequestMapping(value="/logout", method=RequestMethod.GET)
	@ResponseBody
	public String logout(HttpServletRequest request, HttpSession session) {
		session.setAttribute("nickname", "");
		return "{\"result\": \"success\"}";
	}
		

	@RequestMapping(value="/add", method=RequestMethod.POST)
	@ResponseBody
	public String add(HttpServletRequest request, HttpSession session) {
		String nickname = (String)session.getAttribute("nickname");
		String contents = request.getParameter("contents");
		System.out.println("nickname : " + nickname + "contents : " + contents);
		ChatData chatData = ChatData.builder()
				.message(contents)
				.nickname(nickname)
				.build();
		chatDataRepository.save(chatData);
		return "OK";
	}
	
	@RequestMapping(value="/list", method=RequestMethod.GET)
	@ResponseBody
	public String listREST(HttpServletRequest request) {
		List<ChatData> resultList = chatDataRepository.findAll(Sort.by(Sort.Direction.ASC, "id"));
		String json = new Gson().toJson(resultList);
		System.out.println(json);
		return json;
	}
	
	@RequestMapping(value="/del", method=RequestMethod.POST)
	@ResponseBody
	public String del(HttpServletRequest request, HttpSession session) {
		String idStr = request.getParameter("id");
		String nickname = (String)session.getAttribute("nickname");
		Long id = Long.parseLong(idStr);
		Long findCount = chatDataRepository.countByIdAndNickname(id, nickname);
		if(findCount<=0) {
			return "{\"result\": \"fail\"}";
		}else {
			chatDataRepository.deleteById(id);
			return "{\"result\": \"success\"}";
		}
	}
	
	@RequestMapping(value="/mod", method=RequestMethod.POST)
	@ResponseBody
	public String mod(HttpServletRequest request, HttpSession session) {
		String idStr = request.getParameter("id");
		Long id = Long.parseLong(idStr);
		String message = request.getParameter("contents");
		String nickname = (String) session.getAttribute("nickname");
		System.out.println("수정 메세지 : " + message);
		ChatData chatData = ChatData.builder()
				.id(id)
				.nickname(nickname)
				.message(message)
				.build();
		chatDataRepository.save(chatData);
		return "OK";
	}
}
