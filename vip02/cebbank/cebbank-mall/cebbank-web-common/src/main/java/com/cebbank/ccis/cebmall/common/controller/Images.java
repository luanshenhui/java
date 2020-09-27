package com.cebbank.ccis.cebmall.common.controller;

import com.cebbank.ccis.cebmall.common.components.UploadedFile;
import com.cebbank.ccis.cebmall.common.images.ImageServer;
import com.cebbank.ccis.cebmall.user.model.UserImage;
import com.cebbank.ccis.cebmall.user.service.ImageService;
import com.google.common.base.Function;
import com.google.common.base.Strings;
import com.google.common.base.Throwables;
import com.google.common.collect.ImmutableSet;
import com.google.common.collect.Lists;
import com.google.common.io.Files;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.util.JsonMapper;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import java.util.Iterator;
import java.util.List;
import java.util.Set;

@Controller
@RequestMapping("/api/images")
@Slf4j
public class Images {
	private final static Set<String> allowed_types = ImmutableSet.of("jpeg", "jpg", "png", "gif","bmp");
	@Autowired
	private MessageSources messageSources;

	@Autowired
	private ImageService imageService;

	@Autowired
	private ImageServer imageServer;

	@Value("#{app.imageBaseUrl}")
	private String imageBaseUrl;

	@Value("#{app.imgSizeMax}")
	private long imgSizeMax;

	@RequestMapping(value = "/{imageId}", method = RequestMethod.DELETE, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public boolean deleteImage(@PathVariable("imageId") Long imageId) {//用void会报错com.fasterxml.jackson.databind.ser.std.NullSerializer with modifiers "private"
		User user = UserUtil.getUser();
		if (user == null) {
			throw new ResponseException(401, messageSources.get("user.not.login"));
		}
		Response<UserImage> userImageR = imageService.findUserImageById(imageId);
		if (!userImageR.isSuccess()) {
			log.warn("failed to find userImage by imageId {} when delete", imageId);
			return true;
		}
		UserImage userImage = userImageR.getResult();
		if (!userImage.getUserId().equals(user.getId())) {
			throw new ResponseException(401, messageSources.get("image.delete.noauth"));
		}
		imageService.deleteUserImage(userImage);
		try {
			imageServer.delete(userImage.getFileName());
		} catch (Exception e) {
			log.warn("error happened when deleteFile {} on upyun, error:{}", userImage, e);
		}
		return true;
	}

	@RequestMapping(value = "/batch_delete", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public int batchDelete(@RequestParam("imageIds[]") Long[] imageIds) {
		User user = UserUtil.getUser();
		if (user == null) {
			throw new ResponseException(401, messageSources.get("user.not.login"));
		}
		int successCount = 0;
		for (Long imageId : imageIds) {
			Response<UserImage> userImageR = imageService.findUserImageById(imageId);
			if (!userImageR.isSuccess()) {
				log.warn("failed to find userImage by imageId {} when delete", imageId);
				continue;
			}
			UserImage userImage = userImageR.getResult();
			if (!userImage.getUserId().equals(user.getId())) {
				log.warn("image {} not belong to user {}", userImage.getId(), user.getId());
				continue;
			}
			imageService.deleteUserImage(userImage);
			try {
				imageServer.delete(userImage.getFileName());
			} catch (Exception e) {
				log.warn("error happened when deleteFile {} on file server, error:{}", userImage, e);
				continue;
			}
			successCount++;
		}
		return successCount;
	}

	@RequestMapping(value = "/upload", method = RequestMethod.POST, produces = MediaType.TEXT_PLAIN_VALUE)
	@ResponseBody
	public String processUpload(@RequestParam(required = false) String category, MultipartHttpServletRequest request) {
		User user = UserUtil.getUser();
		if (user == null) {
			throw new ResponseException(401, messageSources.get("user.not.login"));
		}
		Iterator<String> fileNameItr = request.getFileNames();
		List<UploadedFile> result = Lists.newArrayList();
		while (fileNameItr.hasNext()) {
			String name = fileNameItr.next();
			MultipartFile file = request.getFile(name);
			String userId = user.getId();
			String originalFilename = userId + "_" + file.getOriginalFilename();
			String ext = Files.getFileExtension(originalFilename).toLowerCase();
			if (allowed_types.contains(ext)) {
				try {
					byte[] imageData = file.getBytes();

					// if size of the image is more than imgSizeMax,it will raise an 500 error
					if (imageData.length > imgSizeMax) {
						result.add(new UploadedFile(name, messageSources.get("image.size.exceed")));
						continue;
					}

					String filePath = imageServer.upload(originalFilename, file);
					// 若成功返回路径则代表上传成功
					boolean isSucceed = !Strings.isNullOrEmpty(filePath);
					if (!isSucceed) {
						log.error("write file(name={}) of user(id={}) to image server failed", filePath, userId);
						result.add(new UploadedFile(name, messageSources.get("image.upload.fail")));
						continue;
					}
					UserImage userImage = new UserImage();
					userImage.setUserId(userId);
					userImage.setCategory(Strings.isNullOrEmpty(category) ? null : category);
					userImage.setFileName(filePath);
					userImage.setFileSize((int) file.getSize());
					imageService.addUserImage(userImage);
					UploadedFile u = new UploadedFile(userImage.getId(), originalFilename,
							Long.valueOf(file.getSize()).intValue(), imageBaseUrl + filePath);
					result.add(u);

				} catch (Exception e) {
					log.error("failed to process upload image {},cause:{}", originalFilename,
							Throwables.getStackTraceAsString(e));
					result.add(new UploadedFile(name, messageSources.get("image.upload.fail")));
				}
			} else {
				result.add(new UploadedFile(name, messageSources.get("image.illegal.ext")));
			}
		}

		int errorCount = 0;
		for (UploadedFile u : result) {
			if (u.getErrorInfo() != null) {
				errorCount++;
			}
		}
		// 如果全失败了就抛错 保持之前上传单个图片时的行为
		if (errorCount == result.size()) {
			throw new ResponseException(500, result.get(0).getErrorInfo());
		}
		return JsonMapper.JSON_NON_EMPTY_MAPPER.toJson(result);
	}

	@RequestMapping(value = "/user", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Pager<UploadedFile> imagesOf(@RequestParam(required = false) String category,
			@RequestParam(value = "p", defaultValue = "1") Integer pageNo,
			@RequestParam(value = "size", defaultValue = "10") Integer size) {
		User user = UserUtil.getUser();
		if (user == null) {
			throw new ResponseException(401, messageSources.get("user.not.login"));
		}
		category = Strings.isNullOrEmpty(category) ? null : category;
		Integer from = (pageNo - 1) * size;
		Response<Pager<UserImage>> result = imageService.findUserImages(user.getId(), category, from, size);
		if (!result.isSuccess()) {
			log.error("failed to find user images for pageNo={} and size={},cause:{}", pageNo, size, result.getError());
			throw new ResponseException(500, messageSources.get("image.query.fail"));
		}
		Pager<UserImage> userImageP = result.getResult();
		return new Pager<UploadedFile>(userImageP.getTotal(),
				Lists.transform(userImageP.getData(), new Function<UserImage, UploadedFile>() {
					@Override
					public UploadedFile apply(UserImage input) {
						return new UploadedFile(input.getId(), null, input.getFileSize(),
								imageBaseUrl + input.getFileName());
					}
				}));
	}





}
