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
  if m == nil then m = 1 end
  if #s ~= 0 then
    Toast.makeText(activity,"获得 "..s,Toast.LENGTH_SHORT).show()
    local ret=Base64.encode(String(s).getBytes(),
    argtable2B64arg(m))
    return String(ret)
  else return String()
  end
end

function b64decode(s,m)
  Toast.makeText(activity,"好像还没实现，药丸",Toast.LENGTH_SHORT).show()
  return ":pill:,蛤"
end

function main()
  if Build.VERSION.SDK_INT >= 19 then
    activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
  end
  onCreateOptionsMenu=function(menu)
    menu.add("编解码模式")
    menu.add("退出")
    menu.add("许可证")
    menu.add("项目地址")
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

  btn_op.onClick=function()
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
  us.onClick=function() Cfg(5) end
end

function openURL(u)
  import "android.content.intent"
  import "android.net.Uri"
  local intent=Intent(Intent.ACTION_VIEW,
  Uri.parse(u))
  activity.startActivity(intent)
end

function Cfg(m)
  import "android.content.SharedPreferences"
  sp=SharedPreferences.getDefaultShardPreferences(activity)
  edit=sp.edit()
  if m ~= nil then
  Toast.makeText(activity,"保存设置 "..m,Toast.LENGTH_SHORT).show()
  edit.putInteger("mode",m)
  else
  return edit.getInteger("mode")
  end
end

main()