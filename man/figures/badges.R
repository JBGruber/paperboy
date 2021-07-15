library(ggplot2)
df <- data.frame(x = 1, y = 1)
plot <- ggplot(df, aes(x, y)) +
  geom_point(shape = 18, size = 40, color = "#ffd700") +
  theme_void()
ggsave("./man/figures/gold.svg", plot, width = 0.9, height = 0.9)

plot <- ggplot(df, aes(x, y)) +
  geom_point(shape = 18, size = 40, color = "#C0C0C0") +
  theme_void()
ggsave("./man/figures/silver.svg", plot, width = 0.9, height = 0.9)

plot <- ggplot(df, aes(x, y)) +
  geom_point(shape = 18, size = 40, color = "#CD7F32") +
  theme_void()
ggsave("./man/figures/bronze.svg", plot, width = 0.9, height = 0.9)
