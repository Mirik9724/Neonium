#version 120

// Входные данные от вершинного шейдера
varying vec2 texCoord;          // Текстурные координаты

// Текстура
uniform sampler2D textureSampler; // Сэмплер текстуры

// Эффекты
uniform bool neonPalette;          // Включить неоновую палитру
uniform float neonSaturation;      // Насыщенность неона
uniform float neonHue;             // Оттенок неона
uniform float neonBrightness;      // Яркость неона

uniform bool bloom;                // Включить эффект блум
uniform float bloomThreshold;      // Порог блум
uniform float bloomStrength;       // Сила блум
uniform float bloomRadius;         // Радиус блум

uniform bool scanlines;            // Включить сканлайны
uniform float scanlineIntensity;   // Интенсивность сканлайнов

uniform bool vignette;             // Включить виньетку
uniform float vignetteStrength;    // Сила виньетки
uniform float vignetteSize;        // Размер виньетки

uniform bool chromaberation;       // Включить хромаберрацию
uniform float chromaberationIntensity; // Интенсивность хромаберрации

uniform bool waveDistortion;       // Включить волну
uniform float waveFrequency;      // Частота волн
uniform float waveAmplitude;      // Амплитуда волн

uniform bool glitch;               // Включить глитчи
uniform float glitchFrequency;     // Частота глитчей
uniform float glitchIntensity;     // Интенсивность глитчей

uniform bool nightMode;            // Включить глубокую ночь
uniform float nightModeIntensity;  // Интенсивность ночи
uniform bool nightModeLightAccents; // Световые акценты в ночи
uniform float nightModeLightIntensity; // Интенсивность акцентов света в ночи

uniform bool lowResFX;             // Включить эффект Low-Res
uniform float lowResIntensity;     // Интенсивность Low-Res
uniform float lowResSize;          // Размер пикселей для Low-Res

void main()
{
    vec4 color = texture2D(textureSampler, texCoord); // Основной цвет из текстуры

    // Эффект неоновой палитры
    if (neonPalette)
    {
        color.rgb = mix(vec3(0.0, 0.0, 0.0), color.rgb, neonSaturation);
        color.rgb = hueShift(color.rgb, neonHue);
        color.rgb *= neonBrightness;
    }

    // Эффект блум
    if (bloom && length(color.rgb) > bloomThreshold)
    {
        color.rgb += color.rgb * bloomStrength * bloomRadius;
    }

    // Эффект сканлайнов
    if (scanlines)
    {
        color.rgb *= 1.0 - scanlineIntensity * mod(gl_FragCoord.y, 2.0);
    }

    // Виньетка
    if (vignette)
    {
        float dist = length(texCoord - vec2(0.5, 0.5));
        color.rgb *= smoothstep(vignetteStrength, vignetteSize, dist);
    }

    // Хромаберрация
    if (chromaberation)
    {
        color.r += chromaberationIntensity;
        color.g -= chromaberationIntensity;
    }

    // Волны
    if (waveDistortion)
    {
        float wave = sin(texCoord.x * waveFrequency + gl_FragCoord.y * waveAmplitude);
        color.rgb += wave * 0.1;
    }

    // Глитч-эффекты
    if (glitch)
    {
        if (mod(gl_FragCoord.x, glitchFrequency) > glitchIntensity)
        {
            color.rgb *= 0.5;
        }
    }

    // Глубокая ночь
    if (nightMode)
    {
        color.rgb *= nightModeIntensity;
        if (nightModeLightAccents)
        {
            color.rgb += nightModeLightIntensity * vec3(1.0, 1.0, 0.5); // Тёплый свет
        }
    }

    // Low-Res эффекты
    if (lowResFX)
    {
        color.rgb = floor(color.rgb * lowResSize) / lowResSize;
    }

    gl_FragColor = color; // Отправляем финальный цвет пикселя
}

vec3 hueShift(vec3 color, float shift)
{
    float angle = shift * 6.283185307179586; // 2 * pi
    mat3 rotationMatrix = mat3(
        cos(angle), -sin(angle), 0.0,
        sin(angle), cos(angle), 0.0,
        0.0, 0.0, 1.0
    );
    return rotationMatrix * color;
}
