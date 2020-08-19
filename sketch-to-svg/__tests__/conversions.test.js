const { arrayFromSketchString, convertLineCapStyle, convertLineJoinStyle } = require('../dist/conversions.js')

describe('pointFromSketchString', () => {

    test('parse valid formatted point', () => {
        expect(arrayFromSketchString("{1,2}")).toEqual([1, 2])
    })

    test('deal with leading/trailing space', () => {
        expect(arrayFromSketchString("  {1,2} ")).toEqual([1, 2])
    })

    test('deal with interior space', () => {
        expect(arrayFromSketchString("{ 1 , 2 }")).toEqual([1, 2])
    })

    test('more than two points', () => {
        expect(arrayFromSketchString("{1,2,3}")).toEqual([1, 2, 3])
    })

    test('just one point', () => {
        expect(arrayFromSketchString("{1}")).toEqual([1])
    })

    test('no points', () => {
        expect(arrayFromSketchString("{ }")).toEqual([])
    })

    test('missing leading {', () => {
        expect(arrayFromSketchString("1, 2}")).toBeUndefined()
    })

    test('missing trailing }', () => {
        expect(arrayFromSketchString("{1, 2")).toBeUndefined()
    })

    test('too short string', () => {
        expect(arrayFromSketchString('{')).toBeUndefined()
    })
})

describe('convertLineCapStyle', () => {

    test('0 -> butt', () => {
        expect(convertLineCapStyle(0)).toEqual("butt")
    })

    test('1 -> round', () => {
        expect(convertLineCapStyle(1)).toEqual("round")
    })

    test('2 -> square', () => {
        expect(convertLineCapStyle(2)).toEqual("square")
    })

    test('3 -> undefined', () => {
        expect(convertLineCapStyle(3)).toBeUndefined()
    })
})

describe('convertLineJoinStyle', () => {

    test('0 -> miter', () => {
        expect(convertLineJoinStyle(0)).toEqual("miter")
    })

    test('1 -> round', () => {
        expect(convertLineJoinStyle(1)).toEqual("round")
    })

    test('2 -> bevel', () => {
        expect(convertLineJoinStyle(2)).toEqual("bevel")
    })

    test('3 -> undefined', () => {
        expect(convertLineJoinStyle(3)).toBeUndefined()
    })
})
