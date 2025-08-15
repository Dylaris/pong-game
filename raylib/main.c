#include <stdio.h>
#include <raylib.h>

Color Green = {38, 185, 154, 255};
Color Dark_Green = {20, 160, 133, 255};
Color Light_Green = {129, 204, 184, 255};
Color Yellow = {243, 213, 91, 255};

typedef struct {
    int x, y;
    int width, height;
    int speed;
} Paddle;

void limit_move(Paddle *paddle)
{
    if (paddle->y < 0) {
        paddle->y = 0;
    } else if (paddle->y + paddle->height > GetScreenHeight()) {
        paddle->y = GetScreenHeight() - paddle->height; 
    }
}

void draw_paddle(Paddle *paddle)
{
    DrawRectangleRounded(
        (Rectangle){paddle->x, paddle->y, paddle->width, paddle->height},
        0.8, 0, WHITE);
}

void update_player_paddle(Paddle *player)
{
    if (IsKeyDown(KEY_UP))   player->y -= player->speed;
    if (IsKeyDown(KEY_DOWN)) player->y += player->speed;

    limit_move(player);
}

void update_enemy_paddle(Paddle *enemy, int ball_y)
{
    if (enemy->y + enemy->height/2 > ball_y) enemy->y -= enemy->speed;
    if (enemy->y + enemy->height/2 < ball_y) enemy->y += enemy->speed;

    limit_move(enemy);
}

typedef struct {
    int speed_x, speed_y;
    int radius;
    int x, y;
} Ball;

static int player_score = 0;
static int enemy_score = 0;

void reset_ball(Ball *ball)
{
    ball->x = GetScreenWidth() / 2;
    ball->y = GetScreenHeight() / 2;

    int speed_choices[] = {1, -1};
    ball->speed_x *= speed_choices[GetRandomValue(0, 1)];
    ball->speed_y *= speed_choices[GetRandomValue(0, 1)];
}

void update_ball(Ball *ball)
{
    ball->x += ball->speed_x;
    ball->y += ball->speed_y;

    if (ball->y + ball->radius >= GetScreenHeight() || 
        ball->y - ball->radius <= 0) {
        ball->speed_y *= -1;
    }
    if (ball->x + ball->radius >= GetScreenWidth()) {
        enemy_score++;
        reset_ball(ball);
    } else if (ball->x - ball->radius <= 0) {
        player_score++;
        reset_ball(ball);
    }
}

void draw_ball(Ball *ball)
{
    DrawCircle(ball->x, ball->y, ball->radius, Yellow);
}

void check_collision(Ball *ball, Paddle *paddle)
{
    if (CheckCollisionCircleRec(
            (Vector2){ball->x, ball->y},
            ball->radius,
            (Rectangle){paddle->x, paddle->y, paddle->width, paddle->height})) {
        ball->speed_x *= -1;
    }
}

int main(void)
{
    const int screen_width = 640;
    const int screen_height = 480;
    const int paddle_width = 15;
    const int paddle_height = 120;
    const int paddle_gap = 5;
    InitWindow(screen_width, screen_height, "My Pong Game!");
    SetTargetFPS(60);

    Ball ball = {
        .radius = 10,
        .x = screen_width / 2,
        .y = screen_height / 2,
        .speed_x = 4,
        .speed_y = 4
    };

    Paddle player = {
        .width = paddle_width,
        .height = paddle_height,
        .x = screen_width - paddle_width - paddle_gap,
        .y = screen_height/2 - paddle_height/2, 
        .speed = 5
    };

    Paddle enemy = {
        .width = paddle_width,
        .height = paddle_height,
        .x = paddle_gap,
        .y = screen_height/2 - paddle_height/2,
        .speed = 5
    };

    while (!WindowShouldClose()) {
        BeginDrawing();

        // Updating
        update_ball(&ball);
        update_player_paddle(&player);
        update_enemy_paddle(&enemy, ball.y);

        check_collision(&ball, &player);
        check_collision(&ball, &enemy);

        // Drawing
        ClearBackground(Dark_Green);
        DrawRectangle(screen_width/2, 0, screen_width/2, screen_height, Green);
        DrawCircle(screen_width/2, screen_height/2, 150, Light_Green);
        DrawLine(screen_width/2, 0, screen_width/2, screen_height, WHITE);
        draw_ball(&ball);
        draw_paddle(&enemy);
        draw_paddle(&player);
        DrawText(TextFormat("%i", enemy_score), screen_width/4-20, 20, 80, WHITE);
        DrawText(TextFormat("%i", player_score), 3*screen_width/4-20, 20, 80, WHITE);

        EndDrawing();
    }

    CloseWindow();
    return 0;
}
