#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <signal.h>

#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>

#define KEYFILESIZE 41

void handler(int sig){
  puts("GOT IT");
  exit(1);
}

void readKey(sock){
  char buf[KEYFILESIZE];
  FILE* keyFile=fopen("./key","r");
  fread(buf,1,KEYFILESIZE,keyFile);
  write(sock,buf,KEYFILESIZE);
  return;
}

void firstFunc(int FD){ 
  char buf[0x1000];
  int cookie=*(int*)(buf+0x1000);
  printf("cookie: %x\n",cookie);
  read(FD,buf,0x2000);
  return;
}

int servlet(int fd){
  signal(SIGALRM,handler);
  alarm(2);
  
  firstFunc(fd);
  char* sorry="Sorry Bro :(";
  write(fd,sorry,strlen(sorry));
  return 0;
}

int main(int argc, char *argv[])
{
  //char buffer[BUFFER_SIZE];
  int sockfd, newsockfd, portno, pid;
  socklen_t clilen;
  struct sockaddr_in serv_addr, cli_addr;
   if (argc < 2) {
    fprintf(stderr,"ERROR, no port provided\n");
    exit(1);
  }
  sockfd = socket(AF_INET, SOCK_STREAM, 0);
  if (sockfd < 0)
    error("ERROR opening socket");
  bzero((char *) &serv_addr, sizeof(serv_addr));
  portno = atoi(argv[1]);
  serv_addr.sin_family = AF_INET;
  serv_addr.sin_addr.s_addr = INADDR_ANY;
  serv_addr.sin_port = htons(portno);
  if (bind(sockfd, (struct sockaddr *) &serv_addr,
	   sizeof(serv_addr)) < 0)
    error("ERROR on binding");
  listen(sockfd,5);
  clilen = sizeof(cli_addr);
  while (1) {
    newsockfd = accept(sockfd,
		       (struct sockaddr *) &cli_addr, &clilen);
    if (newsockfd < 0)
      error("ERROR on accept");
    pid = fork();
    if (pid < 0)
      error("ERROR on fork");
    if (pid == 0)  {
      close(sockfd);
      servlet(newsockfd);
      exit(0);
    }
    else close(newsockfd);
  }
  close(sockfd);
  return 0; 
}
