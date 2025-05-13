#version 120

// Входные данные для вершинного шейдера
attribute vec3 inPosition;      // Позиция вершины
attribute vec2 inTexCoord;      // Текстурные координаты
attribute vec3 inNormal;        // Нормали

// Выходные данные для фрагментного шейдера
varying vec2 texCoord;          // Текстурные координаты

// Матрицы преобразования
uniform mat4 modelViewMatrix;   // Матрица модели
uniform mat4 projectionMatrix;  // Матрица проекции

void main()
{
    texCoord = inTexCoord;      // Передаем текстурные координаты
    gl_Position = projectionMatrix * modelViewMatrix * vec4(inPosition, 1.0); // Преобразование координат
}
