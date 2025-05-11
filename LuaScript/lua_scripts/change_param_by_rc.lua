local socket = require("socket")

-- номер каналу, значення якого ми будемо перевіряти

local rc_channel_num = 7

local delay_main_function = 1
local delay_write_params = 0.02

local default_params_flag = false
local new_params_flag = true


-- словник параметрів для дефолтних значень
-- щоб додати свої параметри, просто додайте їх черз кому в словник - ["<Назва параметру>"] = <значення параметру>

local default_params_dict = {
    ["AHRS_TRIM_X"] = 0,
    ["AHRS_TRIM_Y"] = 0,
}

-- словник параметрів для зміни даних
-- щоб додати свої параметри, просто додайте їх черз кому в словник - ["<Назва параметру>"] = <значення параметру>

local new_params_dict = {
    ["AHRS_TRIM_X"] = 3.14,
    ["AHRS_TRIM_Y"] = 3.14,
}


-- функція для перевірки стану каналу rc, який буде давати ШІМ. Повертає true/false
function check_lvl_rc()
    local pwm_value = get_pwm(rc_channel_num)
    gcs:send_text(pwm_value)
    if 900 < pwm_value < 1500 then
        return false
    else
        return true
    end
end


-- функція для зміни параметрів на нові
function update_params(status)
    if status and new_params_flag then
        --for key, value in pairs(new_params_dict) do
          --  print(key, value)
        --end
        print("update_params")
        gcs:send_text("update_params")
        new_params_flag = false
        default_params_flag = true
    end
end


-- функція для повернення параметрів до дефолтних значень
function return_2_default(status)
    if status == false and default_params_flag then
        print("return_2_default")
        gcs:send_text("return_2_default")

        new_params_flag = true
        default_params_flag = false
    end
end


-- головна функція скрипта, де перевіряється значення rc та виконує певну дію в залежності від значення
function main()

    gcs:send_text(0, "run script")

    return main, 1000
end


-- запускаємо функцію main
main()