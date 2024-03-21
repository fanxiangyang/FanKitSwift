import XCTest
@testable import FanKitSwift

final class FanKitSwiftTests: XCTestCase {
    ///基本测试
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        print(FanKitSwift().text)
        print("wemfdskfjdslfk")
        
        let hexColor = FanColor(hex:"f33245")
        print("hex颜色:\(hexColor)")
        
        XCTAssertEqual(FanKitSwift().text, "Hello, World!")
        
    }
    func testTool() throws {
        let json:[String : Any] = ["name":"fan","age":30]
        let jsonStr:String = "{\"name\":\"fan\",\"age\":30}"
        print("json字符串：\(FanTool.fan_dic(jsonStr))")
        let filePath = FanPath(fileAllName: "heartos.json")
        
        print("json字符串路径：\(FanTool.fan_dic(jsonPath: filePath))")
        
        let jsonArr:String = "[\"name\",\"fan\",\"age\",\"30\"]"
        print("json字符串数组：\(FanTool.fan_array(jsonArr))")
        
        
        print("路径：\(FanTool.fan_documentPath())")
        
        print("路径1：\(FanTool.fan_cachePath())")
        //    FanTool.fan_tmpPath = "23456"
        print("路径2：\(FanTool.fan_tmpPath())")
        
        let tmpPath = FanTool.fan_tmpPath().appending("/abc/a.json")
        let tmpPath2 = FanTool.fan_tmpPath().appending("/def/a.json")
        FanTool.fan_copy(atPath: FanPath(fileAllName: "heartos.json"), toPath: tmpPath)
        FanTool.fan_copy(atPath: FanPath(fileAllName: "heartos.json"), toPath: tmpPath2)
        print("json字符串路径：\(FanTool.fan_dic(jsonPath: tmpPath))")
        
        let copyPath = FanTool.fan_cachePath().appending("/fan")
        FanTool.fan_copy(from: FanTool.fan_tmpPath(), to: copyPath)
        
        FanTool.fan_move(frome: copyPath, to: FanTool.fan_cachePath().appending("/fan2"),removeOld: true)
        
        print("文件夹大小：\(FanTool.fan_folderSize(tmpPath))")
        print("文件夹大小2：\(FanTool.fan_folderSize(FanTool.fan_cachePath()))")

        //    FanTool.fan_delete(copyPath+"/a.json")
    //    FanTool.fan_delete(atPath: copyPath)
        
        let enumerator = FileManager.default.enumerator(atPath: FanTool.fan_cachePath())
        while let file = enumerator?.nextObject() {
            if let fileName = file as? String{
                print("文件遍历：\(fileName)")
            }
            
        }
        
        var str1 =  "沃尔玛"
        str1.append("fan")
        
        print("字符串追加：\(str1)")
        
        let tmpUrl = URL(string: tmpPath)
        let tmpUrl2 = NSURL(fileURLWithPath: tmpPath)
        print(tmpUrl?.absoluteString,tmpUrl?.fan_path)
        print(tmpUrl2.absoluteString,tmpUrl2.path)
        
    }
    ///测试Data数据处理
    public func testData() throws{
        let dic = ["a":"b","data":["abc","xxx"]] as NSDictionary
        let a = dic.fan_bool("data")
        let arr:[Any] = dic.fan_array("data")
        var arr1 = dic.fan_nsarray("data")
        arr1 = ["aa"]
        let dic2:NSDictionary = [:]
        
        print("判断是否是小端：\(Data.fan_isLittleEndian())")
        
        let a16:Int16 = 0x0102
        let data16 = Data.fan_packInt16(a16)
        print("Data生成：",data16,data16.fan_unpackInt16(bigEndian: true))
        var result = Int16(bigEndian: data16.withUnsafeBytes({d in
            d.load(as: Int16.self)
        }))
        result = Int16(bigEndian: a16)
        print("Data生成Int16：",result)
        
        let f32:Float32 = 0.19
        let dataf32 = Data.fan_packFloat32(f32,bigEndian: true)
        let desData = dataf32.fan_des
        
        print("16进制字符串：\(data16.fan_hexString)")
        print("16进制字符串：\(desData.fan_p1)")
        let hexData = data16.fan_hexString.fan_hexData
        print("16进制字符串-Data：\(hexData)")
        print("16进制字符串-Int：\("01000001".fan_hexToInt)")
        print("16进制字符串-ASC：\("342b3c41".fan_hexToAscString)")


        print("MD5字符串：\("01000001".fan_md5)")

    }
    public func testToolWifi() throws{
        print("所有IP地址：\(FanTool.fan_allIPAddress())")
        
    }
}
