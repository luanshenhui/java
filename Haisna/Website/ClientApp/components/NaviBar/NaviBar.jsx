import React from 'react';
import { Link } from 'react-router-dom';
import styled from 'styled-components';

import NaviForm from './NaviForm';
import Logo from '../Logo';

const Wrapper = styled.nav`
  background-color: #666666;
  box-sizing: border-box;
  height: 60px;
  left: 0;
  position: fixed;
  width: 100%;
`;

const Content = styled.div`
  align-items: center;
  display: flex;
  height: 60px;
  justify-content: space-between;
  padding-right: 15px;
`;

const LeftSide = styled.div`
  display: flex;
`;

const Separator = styled.span`
  border-right: 1px solid #fff;
`;

const Menu = styled.div`
  align-items: center;
  display: flex;
  font-size: 13px;
`;

const MenuItem = styled(Link)`
  color: #fff;
  padding: 0 13px;
`;

const MenuSeparator = Separator.extend`
  height: 20px;
`;

const RightSide = styled.div`
  align-items: center;
  display: flex;
  justify-content: flex-end;
`;

const NaviBar = () => (
  <Wrapper>
    <Content>
      <LeftSide>
        <Link to="">
          <Logo />
        </Link>
        <Separator />
        <Menu>
          <MenuItem to="/contents/reserve">予約</MenuItem>
          <MenuSeparator />
          <MenuItem to="/contents/dailywork">当日</MenuItem>
          <MenuSeparator />
          <MenuItem to="/contents/result">結果</MenuItem>
          <MenuSeparator />
          <MenuItem to="/contents/judgement">判定</MenuItem>
          <MenuSeparator />
          <MenuItem to="/contents/inquiry">結果参照</MenuItem>
          <MenuSeparator />
          <MenuItem to="/contents/report">印刷</MenuItem>
          <MenuSeparator />
          <MenuItem to="/contents/demand">請求</MenuItem>
          <MenuSeparator />
          <MenuItem to="/contents/download">データ</MenuItem>
          <MenuSeparator />
          <MenuItem to="/contents/preference">メンテナンス</MenuItem>
          <MenuSeparator />
          <MenuItem to="/contents/followup">フォローアップ</MenuItem>
          <MenuSeparator />
          <MenuItem to="/sample">home</MenuItem>
          <MenuSeparator />
        </Menu>
      </LeftSide>
      <RightSide>
        <NaviForm />
      </RightSide>
    </Content>
  </Wrapper>
);

export default NaviBar;
