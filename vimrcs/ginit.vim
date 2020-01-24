if has("win32")
    GuiTabline 0
    GuiPopupmenu 0
    try
        GuiFont Source\ Code\ Pro:h10
    catch
        GuiFont Consolas:h10
    endtry
endif
