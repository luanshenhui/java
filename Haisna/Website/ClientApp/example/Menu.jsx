import React from 'react';
import { Route, Link } from 'react-router-dom';
import List from '@material-ui/core/List';
import ListItem from '@material-ui/core/ListItem';
import ListItemText from '@material-ui/core/ListItemText';
import styled from 'styled-components';

import AlertExample from './AlertExample';
import ButtonExample from './ButtonExample';
import ChipExample from './ChipExample';
import DatePickerExample from './DatePickerExample';
import FormExample from './FormExample';
import DropDownPreset from './DropDownPreset';
import ModalExample from './ModalExample';
import PageExample from './PageExample';
import TableExample from './TableExample';
import PaginationExample from './PaginationExample';
import GuideExample from './GuideExample';

const width = 300;

const menuItems = [
  { id: 1, url: '/sample/alert', caption: 'アラート' },
  { id: 2, url: '/sample/button', caption: 'ボタン' },
  { id: 3, url: '/sample/chip', caption: 'チップ' },
  { id: 4, url: '/sample/datepicker', caption: 'DatePicker' },
  { id: 5, url: '/sample/form', caption: 'フォーム' },
  { id: 6, url: '/sample/dropdown/preset', caption: 'ドロップダウン（プリセット）' },
  { id: 7, url: '/sample/modal', caption: 'モーダル' },
  { id: 8, url: '/sample/pageandsection', caption: 'ページ・セクション' },
  { id: 9, url: '/sample/pagination', caption: 'ページネーション' },
  { id: 10, url: '/sample/table', caption: 'テーブル' },
  { id: 11, url: '/sample/guide', caption: 'ガイド' },
];

const Sidebar = styled.nav`
  position: fixed;
  width: ${width}px;
`;

const MainContents = styled.div`
  margin-left: ${width}px;
  padding: 20px;
`;

const Menu = () => (
  <div>
    <Sidebar>
      <List>
        {menuItems.map((rec) => (
          <ListItem button key={`item${rec.id}`}>
            <ListItemText>
              <Link to={rec.url}>{rec.caption}</Link>
            </ListItemText>
          </ListItem>
        ))}
      </List>
    </Sidebar>
    <MainContents>
      <Route exact path="/sample/alert" component={AlertExample} />
      <Route exact path="/sample/button" component={ButtonExample} />
      <Route exact path="/sample/chip" component={ChipExample} />
      <Route exact path="/sample/datepicker" component={DatePickerExample} />
      <Route exact path="/sample/form" component={FormExample} />
      <Route exact path="/sample/dropdown/preset" component={DropDownPreset} />
      <Route exact path="/sample/modal" component={ModalExample} />
      <Route exact path="/sample/pageandsection" component={PageExample} />
      <Route exact path="/sample/table" component={TableExample} />
      <Route exact path="/sample/pagination" component={PaginationExample} />
      <Route exact path="/sample/guide" component={GuideExample} />
    </MainContents>
  </div>
);

export default Menu;
