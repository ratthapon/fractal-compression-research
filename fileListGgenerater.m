setASinglePhoneIdx = [1 2 13 15 16 22 25 31 39 41 43 45 47 48 55 61 81 99 106 107 108 109 116 118 121 122 124 132 133 134 135 136 137 139 154 155 157 158 159 175 206 213 214 215 221 222 223 232 240 241 244 249 258 260 285 291 294 303 308 310 318 321 372 384 389 397 411];
setBSinglePhoneIdx = [1 20 30 33 34 43 52 58 60 126 183 185 187 188 190 207 208 209 210 211 212 214 216 222 229 230 245 247 248 249 250 251 254 257 259 261 266 267 271 275 282:293 295:299 300 303 305 307 310 313 314 316 317 318 319 320 372:393 396:399 403 411 416 417 418 419 427 428 429 431 433 435 437 453 455 460 ];

dirPath = 'F:\IFEFSR\SpeechData\NECTEC';
environment = 'C';
gender = 'FM';
setNumber = [1];
idList = setASinglePhoneIdx;
[listFileName listClassLabel] = buildFileList(dirPath,environment,gender,setNumber,idList);
% setNumber = [2];
% wordCount = max(cell2mat(listClassLabel1));
% idList = setBSinglePhoneIdx;
% listFileName2 = [];
%[listFileName2 listClassLabel2] = [];%buildFileList(dirPath,environment,gender,setNumber,idList);
% listClassLabel2 = [];%cell2mat(listClassLabel2) + wordCount;
% listClassLabel = [listClassLabel1 ; listClassLabel2];
% [listFileName listClassLabel ]= buildFileList(dirPath,environment,gender,setNumber,idList);

fid = fopen('F:\IFEFSR\fileList.txt','w');
fprintf(fid,'%s\n',listFileName{:});
fclose(fid);

fid = fopen('F:\IFEFSR\classList.txt','w');
fprintf(fid,'%s\n',listClassLabel{:});
fclose(fid);

% save('F:\IFEFSR\listFileName1','listFileName')
% save('F:\IFEFSR\listClassLabel1','listClassLabel')
