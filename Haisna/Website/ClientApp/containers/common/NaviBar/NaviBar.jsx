// @flow

import * as React from 'react';
import { Field, reduxForm } from 'redux-form';
import { Link } from 'react-router-dom';
import AppBar from '@material-ui/core/AppBar';
import Toolbar from '@material-ui/core/Toolbar';
import moment from 'moment';

import type { FieldProps, FormProps } from 'redux-form';

// コンポーネントのインポート
import Logo from '../../../components/Logo/Logo';
import NaviMenu from '../../../components/NaviBar/NaviMenu/NaviMenu';
import NaviMenuSeparator from '../../../components/NaviBar/NaviMenuSeparator/NaviMenuSeparator';
import NaviText from '../../../components/NaviBar/NaviText/NaviText';
import NaviSearchButton from '../../../components/NaviBar/NaviSearchButton/NaviSearchButton';
import NaviDailyListButton from '../../../components/NaviBar/NaviDailyListButton/NaviDailyListButton';
import NaviAccountButton from '../../../components/NaviBar/NaviAccountButton/NaviAccountButton';

// cssのインポート
import styles from './NaviBar.css';

// 検索フォームコンポーネントの定義
const SearchForm = ({ handleSubmit }: FormProps) => (
  <form className={styles.searchForm} onSubmit={handleSubmit}>
    <Field
      name="keyword"
      component={({ input }: FieldProps): Object => (
        <NaviText {...input} />
      )}
    />
    <NaviSearchButton />
  </form>
);

// 検索フォームコンポーネントのredux-Form化
const SearchFormContainer = reduxForm({
  form: 'naviBarSearchForm',
})(SearchForm);

// コンポーネントの定義
const NaviBar = ({ onSubmit }: { onSubmit?: Function }) => (
  <AppBar className={styles.naviBar}>
    <Toolbar>
      <Link to="/">
        <Logo />
      </Link>
      <NaviMenu className={styles.menu}>
        <NaviMenuSeparator className={styles.separator} />
        <Link to="/contents/reserve" className={styles.menuItem}>予約</Link>
        <NaviMenuSeparator className={styles.separator} />
        <Link to="/contents/dailywork" className={styles.menuItem}>当日</Link>
        <NaviMenuSeparator className={styles.separator} />
        <Link to="/contents/result" className={styles.menuItem}>結果</Link>
        <NaviMenuSeparator className={styles.separator} />
        <Link to="/contents/judgement" className={styles.menuItem}>判定</Link>
        <NaviMenuSeparator className={styles.separator} />
        <Link to="/contents/inquiry" className={styles.menuItem}>結果参照</Link>
        <NaviMenuSeparator className={styles.separator} />
        <Link to="/contents/report" className={styles.menuItem}>印刷・ダウンロード</Link>
        <NaviMenuSeparator className={styles.separator} />
        <Link to="/contents/demand" className={styles.menuItem}>請求</Link>
        <NaviMenuSeparator className={styles.separator} />
        <Link to="/contents/preference" className={styles.menuItem}>メンテナンス</Link>
        <NaviMenuSeparator className={styles.separator} />
        <Link to="/contents/followup" className={styles.menuItem}>フォローアップ</Link>
        <NaviMenuSeparator className={styles.separator} />
        <Link to="/sample" className={styles.menuItem}>サンプル</Link>
        <NaviMenuSeparator className={styles.separator} />
      </NaviMenu>
      <SearchFormContainer onSubmit={onSubmit} />
      <Link to={`/reserve/frontdoor/dailylist?strDate=${encodeURIComponent(moment().format('YYYY/M/D'))}`} className={styles.buttonLink}>
        <NaviDailyListButton />
      </Link>
      <NaviAccountButton />
    </Toolbar>
  </AppBar>
);

// defaultPropsの定義
NaviBar.defaultProps = {
  onSubmit: undefined,
};

export default NaviBar;
