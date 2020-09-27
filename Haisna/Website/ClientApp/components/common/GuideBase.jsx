import React from 'react';
import PropTypes from 'prop-types';
import styled from 'styled-components';
import AppBar from '@material-ui/core/AppBar';
import IconButton from '@material-ui/core/IconButton';
import Modal from '@material-ui/core/Modal';
import Paper from '@material-ui/core/Paper';
import Clear from '@material-ui/icons/Clear';

import Pagination from '../Pagination';

// Modelを画面中央に表示するための設定
const Guide = styled(Modal)`
  && {
    justify-content: center;
    align-items: center;
  }
`;

// タイトルバーのスタイル定義
const Titlebar = styled.div`
  display: flex;
  align-items: center;
`;

// タイトルのスタイル定義
const Title = styled.span`
  flex: 1;
  padding-left: 15px;
`;

// ガイド内部のスタイル定義
const Content = styled(Paper)`
  && {
    padding: 10px;
  }
`;

const Wrapper = styled.div`
  height: 60px;
`;

class GuideBase extends React.Component {
  // propが更新される際に呼ばれる処理
  componentWillReceiveProps(nextProps) {
    // プロパティの参照
    const { onSelected, onClose } = this.props;
    // 選択された要素が存在する場合
    if (nextProps.selectedItem) {
      // 要素が選択された際のイベントが定義されている場合は呼び出す
      if (onSelected) {
        onSelected(nextProps.selectedItem);
      }
      // クローズイベントを呼び出す
      onClose();
    }
  }

  render() {
    // プロパティの参照
    const { visible, children, title, onClose, page, limit, totalCount, onSearch, usePagination } = this.props;
    // 描画処理
    return (
      <Guide
        open={visible}
        onClose={onClose}
      >
        <Paper>
          <AppBar position="static" elevation={0}>
            <Titlebar>
              <Title>{title}</Title>
              <IconButton disableRipple onClick={onClose}>
                <Clear />
              </IconButton>
            </Titlebar>
          </AppBar>
          <Content>
            {children}
            {usePagination && (
              <Wrapper>
                {/* ページネーションは総ページ数が2ページ以上になる場合、即ち総ページ数＞1ページ当たりの検索件数になる場合にのみ表示 */}
                {/* react本家でもこのような条件指定を行う記述方法が紹介されている */}
                {totalCount > limit && (
                  <Pagination
                    onSelect={onSearch}
                    totalCount={totalCount}
                    startPos={((page - 1) * limit) + 1}
                    rowsPerPage={limit}
                  />
                )}
              </Wrapper>
            )}
          </Content>
        </Paper>
      </Guide>
    );
  }
}

// propTypesの定義
GuideBase.propTypes = {
  // 親からpropsとして渡される項目
  title: PropTypes.string.isRequired,
  usePagination: PropTypes.bool.isRequired,
  page: PropTypes.number,
  limit: PropTypes.number,
  totalCount: PropTypes.number,
  onSearch: PropTypes.func,
  onSelected: PropTypes.func,
  // stateと紐付けされた項目
  visible: PropTypes.bool.isRequired,
  selectedItem: PropTypes.shape(),
  // actionと紐付けされた項目
  onClose: PropTypes.func.isRequired,
  // ネスト要素
  children: PropTypes.oneOfType([
    PropTypes.arrayOf(PropTypes.node),
    PropTypes.node,
  ]).isRequired,
};

// defaultPropsの定義
GuideBase.defaultProps = {
  page: 0,
  limit: 0,
  totalCount: 0,
  onSearch: undefined,
  onSelected: undefined,
  selectedItem: undefined,
};

export default GuideBase;
