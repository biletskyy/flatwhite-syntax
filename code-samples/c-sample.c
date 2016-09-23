#include<stdio.h>

int main()
{
    int avg = 0;
    int sum =0;
    int x=0;

    /* Array- declaration – length 20*/
    int num[20];

    /* for loop for receiving inputs from user and storing it in array*/
    for (x=0; x<=19;x++)
    {
        printf("enter the integer number %d\n", x);
        scanf("%d", &num[x]);
    }
    for (x=0; x<=19;x++)
    {
        sum = sum+num[x];
    }

    avg = sum/20;
    printf("%d", avg);
    return 0;
}

struct StudentData{
    char *stu_name;
    int stu_id;
    int stu_age;
}

const PI = true
