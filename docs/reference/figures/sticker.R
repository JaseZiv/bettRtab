library(hexSticker)


sysfonts::font_add_google(name = "Chivo", family = "chivo")

sticker(subplot = "man/figures/money-bag-pile.png",
        package="bettRtab",
        p_family = "chivo", p_size=60, p_color = "#006600",
        s_x=1, s_y=.8, s_width=0.4, s_height=0.55,
        dpi = 1000,
        h_fill = "white", h_color = "#006600",
        url = "https://jaseziv.github.io/bettRtab/", u_y = 0.07, u_x = 1.0, u_size = 15, u_color = "#006600", u_family = "chivo",
        filename="man/figures/logo.png")





# smaller size hex logo:
sticker(subplot = "man/figures/money-bag-pile.png",
        package="bettRtab",
        p_family = "chivo", p_size=60, p_color = "#006600",
        s_x=1, s_y=.8, s_width=0.4, s_height=0.55,
        dpi = 1000,
        h_fill = "white", h_color = "#006600",
        url = "https://jaseziv.github.io/bettRtab/", u_y = 0.07, u_x = 1.0, u_size = 15, u_color = "#006600", u_family = "chivo",
        filename="man/figures/logo_small_size.png") # modify size in viewer to dimensions 181x209 as a png
