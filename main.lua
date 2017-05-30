require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "layout"
import "optionlayout"

import "android.util.Base64"
import "android.widget.FrameLayout"
import "android.widget.EditText"
import "android.widget.Toast"
import "android.os.Build"

import "java.lang.String"

--activity.setTitle('Linbase64')
activity.setContentView(loadlayout(layout))

collectgarbage(start,100) --把gc的回收间隔调大，好像是吧。。。

PROG_URL="http://github.com/pigfromchina/linbase64"
--MODE=1

--[[B64mets={
  default;
  nopd;
  nowp;
  noclose;
  urlsfe;
  crlf;
}]]
ctable={
  [1]=function() return Base64.DEFAULT end;
  [2]=function() return Base64.NO_PADDING end;
  [3]=function() return Base64.NO_WRAP end;
  [4]=function() return Base64.NO_CLOSE end;
  [5]=function() return Base64.URL_SAFE end;
  [6]=function() return Base64.CRLF end;
}

function argtable2B64arg(m)
  return ctable[m]
end

function base64encode(s,m)
  --if m == nil then m = 1 end
  Toast.makeText(activity,"获得 "..s,Toast.LENGTH_SHORT).show()
  local ret=Base64.encode(String(s).getBytes(),
  argtable2B64arg(m))
  return String(ret)
end

function b64decode(s,m)
  Toast.makeText(activity,"好像还没实现，药丸",Toast.LENGTH_SHORT).show()
  return ":pill:,蛤"
end

function main()
  if Build.VERSION.SDK_INT >= 19 then
    activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
  end
  --activity.getActionBar().setIcon(btn_op.getDrawable())
  onCreateOptionsMenu=function(menu)
    menu.add("编解码模式")
    menu.add("退出")
    menu.add("许可证")
    menu.add("项目地址")
    menu.add("色彩")
  end
  function onMenuItemSelected(i,t) 
    if y[t.getTitle()] then 
      y[t.getTitle()]() 
    end 
  end 

  y={}
  y["退出"]=function() activity.finish() end
  y["编解码模式"]=function() onCodingSetting() end
  y["许可证"]=function() onLicence() end
  y["项目地址"]=function() openURL(PROG_URL) end
  y["色彩"]=function() pickcolor() end


  btn_op.onClick=function()
    Toast.makeText(activity,MODE,1).show()
    b64coded=b64encode(text.getText().toString(),getCfg())
    text.setText(b64coded)
  end
end

function onLicence()
  local l = TextView(activity)
  l.setText([[  Copyright (C) 2017 duangsuse
 *
 *     This program is free software: you can redistribute it and/or modify
 *     it under the terms of the GNU General Public License as published by
 *     the Free Software Foundation, either version 3 of the License, or
 *     (at your option) any later version.
 *
 *     This program is distributed in the hope that it will be useful,
 *     but WITHOUT ANY WARRANTY; without even the implied warranty of
 *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *     GNU General Public License for more details.
 *
 *     You should have received a copy of the GNU General Public License
 *     along with this program.  If not, see <http://www.gnu.org/licenses/>.]])
  AlertDialog.Builder(activity)
  .setTitle("许可证")
  .setView(l)
  .show()
end

function onCodingSetting()
  AlertDialog.Builder(activity)
  .setTitle("设置")
  .setView(loadlayout(optionlayout))
  .show()
  df.onClick=function() Cfg(1) end
  us.onClick=function() Cfg(5) end
  np.onClick=function() Cfg(2) end
  nw.onClick=function() Cfg(3) end
  nc.onClick=function() Cfg(4) end
  cr.onClick=function() Cfg(6) end
end

function openURL(u)
  import "android.content.*"
  import "android.net.*"
  local intent = Intent();
  intent.setAction("android.intent.action.VIEW");
  content_url = Uri.parse(u);
  intent.setData(content_url);
  activity.startActivity(intent)
end

function Cfg(m)
  import "android.content.SharedPreferences"
  import "android.preference.PreferenceManager"
  local sp=PreferenceManager.getDefaultSharedPreferences(activity)
  local edit=sp.edit()
  Toast.makeText(activity,"保存设置 "..m,Toast.LENGTH_SHORT).show()
  edit.putInt("mode",m)
  edit.apply()
  --MODE=m
  --else
  -- return edit.getInteger("mode")
  --return MODE
end

function getCfg()
  sp=PreferenceManager.getDefaultSharedPreferences(activity)
  local m=sp.getInt("mode")
  Toast.makeText(activity,"读取 "..m,Toast.LENGTH_SHORT).show()
  return m
end

function pickcolor()
  import "color"
  local a=AlertDialog.Builder(activity)
  .setView(loadlayout(color))
  .setTitle("输入按钮颜色")
  .show()
  p.onClick=function()
    local c=Color()
    c=c.parseColor(code.
    getText().toString())
    code.setBackgroundColor(c)
  end
  ok.onClick=function()
    storecolor(code.getText().toString())
    a.dismiss()
  end
end
function storecolor(ct)
  Toast.makeText(activity,"保存颜色"..ct,Toast.LENGTH_SHORT).show()
end

--圆角背景源码，非原创。
function 背景(c,s)
  import "android.graphics.drawable.GradientDrawable" 
  import "android.graphics.drawable.GradientDrawable_Orientation"
  import "android.graphics.Color"
  import "android.R_attr"
  local C=Color()
  local colors= int { C.RED, C.GRAY, C.CYAN, }
  local gd= GradientDrawable()
  gd.setCornerRadius(s)
  gd.setColor(C.parseColor(c))
  gd.setGradientType(GradientDrawable.RECTANGLE)
  return gd
end

btn_op.setBackground(背景("#88E89F00",85))

main()