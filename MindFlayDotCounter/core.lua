--------------------------------------------------------------------------------
-- Mind Flay Dot Counter (c) 2014 by Siarkowy
-- Released under the terms of GNU GPL v3 license.
--------------------------------------------------------------------------------
-- Written for Xsar and Palkaplus, <Guild of Nox> of HellGround EU.
--------------------------------------------------------------------------------

-- Icon config -----------------------------------------------------------------

local SIZE = 128                        -- size {16, 32, 64, 128, 256}
local TIME = 1                          -- hide time [sec]
local R, G, B, A = 1.0, 1.0, 1.0, 1.0   -- color: red, green, blue, alpha <0; 1>

-- Frame -- Do not touch anything below! ---------------------------------------

MFDC = CreateFrame("Button", "MindFlayDotCounter", UIParent)
MFDC:Hide()
MFDC:SetPoint("CENTER")
MFDC:SetWidth(SIZE)
MFDC:SetHeight(SIZE)
MFDC:SetClampedToScreen(true)
MFDC:SetMovable(true)
MFDC:EnableMouse(true)
MFDC:RegisterForDrag("LeftButton")
MFDC:SetScript("OnDragStart", MFDC.StartMoving)
MFDC:SetScript("OnDragStop", MFDC.StopMovingOrSizing)
MFDC:SetScript("OnClick", MFDC.Hide)

local tex = MFDC:CreateTexture("MindFlayDotCounterIcon", "BACKGROUND")
tex:SetTexture("Interface\\Icons\\Spell_Shadow_SiphonMana")
tex:SetVertexColor(R, G, B, A)
tex:SetAllPoints()
tex:Show()
MFDC.tex = tex

-- Class check -----------------------------------------------------------------

if select(2, UnitClass("player")) ~= "PRIEST" then
    return
end

-- Core ------------------------------------------------------------------------

local band = bit.band
local count = 0
local timer

MFDC:SetScript("OnEvent", function(self, event, time, type, sGuid, sName, sFlags,
    dGuid, dName, dFlags, spellId, spellName)
    if spellName ~= "Mind Flay" or not band(sFlags, 1) then
        return
    end

    if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then
        count = 0
    elseif type == "SPELL_PERIODIC_DAMAGE" then
        count = count + 1
    else
        return
    end

    if count == 2 then
        self:Show()
    end
end)

MFDC:SetScript("OnUpdate", function(self, elapsed)
    if not timer then timer = TIME end
    timer = timer - elapsed

    if timer <= 0 then
        timer = nil
        self:Hide()
    end
end)

MFDC:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

-- Slash command ---------------------------------------------------------------

function SlashCmdList.MFDC()
    timer = 10
    MFDC:Show()
end

SLASH_MFDC1 = "/mfdc"
