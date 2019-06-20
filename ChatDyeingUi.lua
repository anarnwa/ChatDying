local function AddChatDyeingDisable(str)
    todo = true
    if str == "" then return end
    for k, v in pairs(ChatDyeingDisable) do
        if v == str then
            todo = false
            break
        end
    end
    if todo then
        table.insert(ChatDyeingDisable, str)
    end
end
local function CreateUIFrames()
    if MainFrame ~= nil then
        MainFrame:Show()
        return
    end
    MainFrame = CreateFrame("Frame", "chatdyeing", UIParent, "PortraitFrameTemplate")
    MainFrame:SetFrameStrata("DIALOG")
    MainFrame:SetWidth(500)
    MainFrame:SetHeight(300)
    MainFrame:SetPoint("CENTER", UIParent)
    MainFrame:SetMovable(true)
    MainFrame:EnableMouse(true)
    MainFrame:RegisterForDrag("LeftButton", "RightButton")
    MainFrame:SetClampedToScreen(true)
    MainFrame.title = _G["chatdyeingTitleText"]
    MainFrame.title:SetText("chatdyeing")
    MainFrame:SetScript("OnMouseDown",
        function(self)
            self:StartMoving()
            self.isMoving = true
        end)
    
    MainFrame:SetScript("OnMouseUp",
        function(self)
            if self.isMoving then
                self:StopMovingOrSizing()
                self.isMoving = false
            end
        end)
    
    local icon = MainFrame:CreateTexture("$parentIcon", "OVERLAY", nil, -8)
    --图标
    icon:SetSize(60, 60)
    icon:SetPoint("TOPLEFT", -5, 7)
    icon:SetTexture("Interface\\FriendsFrame\\Battlenet-Portrait")
    --标题
    Text = MainFrame:CreateFontString("FontString", "OVERLAY", "GameFontNormalLarge")
    Text:SetPoint("TOPLEFT", MainFrame, "TOPLEFT", 20, -25)
    Text:SetWidth(200)
    Text:SetText("ChatDyeing设置")
    --是否开启插件
    Button = CreateFrame("CheckButton", "chatdyeingopened", MainFrame, "UICheckButtonTemplate")
    Button:SetPoint("TOPLEFT", Text, "BOTTOMLEFT", 30, -10)
    _G[Button:GetName() .. "Text"]:SetText("开启插件")
    _G[Button:GetName() .. "Text"]:SetFontObject("GameFontHighlight")
    Button:SetChecked(ChatDyeingSettings.chatdyeingopen == true)
    Button:SetScript("OnClick", function(self)ChatDyeingSettings.chatdyeingopen = (self:GetChecked() or false) end)
    --只过滤小队或团队成员
    Button = CreateFrame("CheckButton", "chatdyeingonlyparty", MainFrame, "UICheckButtonTemplate")
    Button:SetPoint("TOPLEFT", Text, "BOTTOMLEFT", 30, -50)
    _G[Button:GetName() .. "Text"]:SetText("只为小队或团队成员染色")
    _G[Button:GetName() .. "Text"]:SetFontObject("GameFontHighlight")
    Button:SetChecked(ChatDyeingSettings.chatdyeingonlyparty == true)
    Button:SetScript("OnClick", function(self)ChatDyeingSettings.chatdyeingonlyparty = (self:GetChecked() or false) end)
    --忽略不完整的姓名
    Button = CreateFrame("CheckButton", "chatdyeingonlycomplete", MainFrame, "UICheckButtonTemplate")
    Button:SetPoint("TOPLEFT", Text, "BOTTOMLEFT", 30, -90)
    _G[Button:GetName() .. "Text"]:SetText("只为完整姓名-服务器进行染色(变更地图或重载后生效)")
    _G[Button:GetName() .. "Text"]:SetFontObject("GameFontHighlight")
    Button:SetChecked(ChatDyeingSettings.chatdyeingonlycomplete == true)
    Button:SetScript("OnClick", function(self)ChatDyeingSettings.chatdyeingonlycomplete = (self:GetChecked() or false) end)
    --停止记录新数据
    Button = CreateFrame("CheckButton", "chatdyeingstoprecording", MainFrame, "UICheckButtonTemplate")
    Button:SetPoint("TOPLEFT", Text, "BOTTOMLEFT", 30, -130)
    _G[Button:GetName() .. "Text"]:SetText("停止记录新数据")
    _G[Button:GetName() .. "Text"]:SetFontObject("GameFontHighlight")
    Button:SetChecked(ChatDyeingSettings.chatdyeingstoprecording == true)
    Button:SetScript("OnClick", function(self)ChatDyeingSettings.chatdyeingstoprecording = (self:GetChecked() or false) end)
    --清空记录
    Button = CreateFrame("Button", "chatdyeingcleanrecord", MainFrame, "UIPanelButtonTemplate")
    Button:SetSize(120, 30)
    Button:SetNormalFontObject("GameFontNormalSmall")
    Button:SetText("清空已记录数据")
    Button:SetPoint("TOPLEFT", Text, "BOTTOMLEFT", 30, -200)
    Button:SetScript("OnClick", function(self)ChatDyeing = {} end)
    --添加黑名单
    Button = CreateFrame("EditBox", "chatdyeingadddisable", MainFrame, "InputBoxTemplate")
    Button:SetPoint("TOPLEFT", Text, "BOTTOMLEFT", 40, -170)
    Button:SetWidth(150)
    Button:SetHeight(20)
    Button:SetAutoFocus(false)
    Button:SetText("添加染色黑名单")
    Button:SetScript("OnEnterPressed", function(self)AddChatDyeingDisable(self:GetText())self:SetText("添加成功") end)
    Button:SetScript("OnEscapePressed", function(self)self:SetText("添加染色黑名单") end)
    --下拉菜单
    CreateFrame("Button", "chatdyeingdropdownlist", MainFrame, "UIDropDownMenuTemplate")
    chatdyeingdropdownlist:SetPoint("TOPLEFT", Text, "BOTTOMLEFT", 200, -165)
    local tempformat = 0
    local function chatdyeingdropdownlist_OnClick(self, arg1, arg2, checked)
        -- Update temp variable
        tempformat = arg1
        -- Update dropdownmenu text
        UIDropDownMenu_SetText(chatdyeingdropdownlist, ChatDyeingDisable[tempformat])
    end
    local function chatdyeingdropdownlist_Initialize(self, level)
        local info = UIDropDownMenu_CreateInfo()
        info.func = chatdyeingdropdownlist_OnClick
        for i, v in ipairs(ChatDyeingDisable) do
            info.arg1, info.text = i, v
            UIDropDownMenu_AddButton(info)
        end
    end
    UIDropDownMenu_Initialize(chatdyeingdropdownlist, chatdyeingdropdownlist_Initialize)
    UIDropDownMenu_SetWidth(chatdyeingdropdownlist, 148);
    UIDropDownMenu_SetButtonWidth(chatdyeingdropdownlist, 124)
    UIDropDownMenu_SetText(chatdyeingdropdownlist, "移除黑名单")
    UIDropDownMenu_JustifyText(chatdyeingdropdownlist, "LEFT")
    --清除黑名单
    Button = CreateFrame("Button", "chatdyeingclean", MainFrame, "UIPanelButtonTemplate")
    Button:SetSize(50, 30)
    Button:SetNormalFontObject("GameFontNormalSmall")
    Button:SetText("清除")
    Button:SetPoint("TOPLEFT", Text, "BOTTOMLEFT", 400, -165)
    Button:SetScript("OnClick", function(self)
        if tempformat ~= 0 then
            table.remove(ChatDyeingDisable, tempformat)
            UIDropDownMenu_SetText(chatdyeingdropdownlist, "移除黑名单")
        end
    end)
    --显示窗口
    MainFrame:Show()
end

function SlashCmdList.ChatDyeing(msg)
    CreateUIFrames()
end

SLASH_ChatDyeing1 = "/cd"
SLASH_ChatDyeing2 = "/chatdyeing"
