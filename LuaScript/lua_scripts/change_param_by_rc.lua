
-- номер каналу, значення якого ми будемо перевіряти
local rc_channel_num = 7

-- значення pwm для каналу в яких межах, буде виконуватись функція
local pwm_min = 900
local pwm_trim = 1500

local delay_main_function = 1000
local default_params_flag = false
local new_params_flag = true


-- словник параметрів для дефолтних значень
-- щоб додати свої параметри, просто додайте їх через кому в словник - ["<Назва параметру>"] = <значення параметру>
local default_params_dict = {
    ["AHRS_TRIM_X"] = 0,
    ["AHRS_TRIM_Y"] = 0,
    ["PTCH_TRIM_DEG"] = 0
}

-- словник параметрів для зміни даних
-- щоб додати свої параметри, просто додайте їх черз кому в словник - ["<Назва параметру>"] = <значення параметру>
local new_params_dict = {
    ["AHRS_TRIM_X"] = 0,
    ["AHRS_TRIM_Y"] = 3.14,
    ["PTCH_TRIM_DEG"] = 20
}


function check_lvl_rc()
    local pwm_value = rc:get_pwm(rc_channel_num)
    --gcs:send_text(6, pwm_value)
    if pwm_value > pwm_min and pwm_value < pwm_trim then
        return false
    else
        return true
    end
end


function update_params(status)
    if status and new_params_flag then

        for key, value in pairs(new_params_dict) do
            param:set(key, value)
        end

        gcs:send_text(6, "LUA: UPDATE PARAMS")
        new_params_flag = false
        default_params_flag = true
    end
end


function return_2_default(status)
    if status == false and default_params_flag then

        for key, value in pairs(default_params_dict) do
            param:set(key, value)
        end

        gcs:send_text(6, "LUA: RETURN TO DEFAULT")
        new_params_flag = true
        default_params_flag = false
    end
end


function main()
    status = check_lvl_rc()
    update_params(status)
    return_2_default(status)

    return main, delay_main_function
end


return main(), delay_main_function
