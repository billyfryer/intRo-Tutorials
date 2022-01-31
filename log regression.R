library(hoopR)
library(tidyverse)
library(ggplot2)

# Get all PBP Data
pbp <- hoopR::load_mbb_pbp() %>% 
  # Create a variable that calculates score differential
  mutate(score_diff = home_score - away_score)

# Find out who won each game
winners <- pbp %>% 
  # By each Game
  group_by(game_id) %>%
  # Go to the last play
    filter(game_play_number == max(game_play_number)) %>% 
  ungroup() %>% 
  # winner = 1 when winner is home and 0 for away winner
  # final_margin = margin of victory
  mutate(winner = case_when(score_diff > 0 ~ 1,
                            score_diff < 0 ~ 0),
         final_margin = home_score-away_score) %>% 
  # Get rid of tip offs
  filter(game_play_number != 1) %>% 
  # Reduce the number of variables
  select(game_id, winner, final_margin)

# explain what a lookup table means

# Join tables together
full_pbp <- left_join(pbp, winners, by = "game_id") %>% 
  # Only keep variables we want
  select(end_game_seconds_remaining, score_diff, 
         home_team_spread, winner, game_play_number, game_id, final_margin) %>% 
  # Get rid of games without a winner
  filter(!is.na(winner))

# Create Linear Model for predicted Win Margin
win_marg_model <- lm(final_margin ~ score_diff + end_game_seconds_remaining,
                     data = full_pbp)

# Create Logistic Win Probability Model
win_prob_model <- glm(winner ~ end_game_seconds_remaining + score_diff,
             data = full_pbp,
             family = "binomial")

# Attach Fitted Values
new_full_pbp <- full_pbp %>% 
  mutate(pred_win_prob = win_prob_model$fitted.values,
         pred_win_marg = win_marg_model$fitted.values,)

# NC State vs Nebraska
new_pbp <- new_full_pbp %>% 
  filter(game_id == 401370106) %>% 
  mutate(new_win_prob = 2*pred_win_prob - 1)

# Win Probability Chart
ggplot(new_pbp, aes(x = game_play_number,
                    y = new_win_prob)) +
  geom_line() +
  ylim(-1,1) +
  labs(x = "# Plays into Game",
       y = "Win Probability of Home Team",
       title = "Basic Win Probability Model",
       subtitle = "NCSU vs Virginia MBB 2021",
       caption = "Created by Billy Fryer ~ Data from hoopR package") +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5),
        plot.subtitle = element_text(hjust = 0.5)
  )

# Predicted Win Margin Chart
ggplot(new_pbp, aes(x = game_play_number,
                    y = pred_win_marg)) +
  geom_line() +
  labs(x = "# Plays into Game",
       y = "Predicted Win Margin",
       title = "Predicted Win Margin by Home Team",
       subtitle = "NCSU vs Virgina MBB 2022",
       caption = "Created by Billy Fryer ~ Data from hoopR package") +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5),
        plot.subtitle = element_text(hjust = 0.5)
  )
