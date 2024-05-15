package com.team4.cbs.util;

import java.io.UnsupportedEncodingException;

import javax.servlet.http.HttpSession;

import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class FileController {
	//요청URI : download?fileName=/team4/PapersFile/%EC%88%98%EC%9E%85%EB%A9%B4%EC%9E%A5.pdf
	@ResponseBody
	@RequestMapping(value="/download",produces=MediaType.APPLICATION_OCTET_STREAM_VALUE)
	public ResponseEntity<Resource> downloadFile(String fileName,
			HttpSession session){
		//?fileName=/team4/PapersFile/%EC%88%98%EC%9E%85%EB%A9%B4%EC%9E%A5.pdf
		log.info("download file : " + fileName);
		
		String realPath = "d:";
		
		//core.io
		Resource resource = new FileSystemResource(
				realPath + fileName
				);
		log.info("path : " + (realPath + fileName));
		
		String resourceName = resource.getFilename();
		log.info("resourceName : " + resourceName);
		
		//springframework.http
		//헤더를 통해서 파일을 보냄
		HttpHeaders headers = new HttpHeaders();
		
		try {
			//파일명을 한글처리함
			headers.add("Content-Disposition", "attachment;filename=" + 
						new String(resourceName.getBytes("UTF-8"),"ISO-8859-1"));
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		//resource : 파일 / header : 파일명 등 정보 / HttpStatus.OK : 상태200(성공)
		return new ResponseEntity<Resource>(resource,headers,HttpStatus.OK);
	}
}









