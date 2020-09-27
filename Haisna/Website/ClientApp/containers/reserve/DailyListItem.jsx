import React from 'react';
import PropTypes from 'prop-types';
import axios from 'axios';
import Chip from '../../components/Chip';
import ItemAndGroupGuide from './ItemAndGroupGuide';

// 検査項目名の取得
class DailyListItem extends React.Component {
  constructor(props) {
    super(props);
    this.state = { itemName: '', show: false };
  }

  componentDidMount() {
    const { params } = this.props;
    const { itemCd, grpCd } = params;
    if (grpCd !== '') {
      this.getGrpInfo(grpCd);
    } else {
      this.getItemInfo(itemCd);
    }
  }

  // propが更新される際に呼ばれる処理
  componentWillReceiveProps(nextProps) {
    const { params } = nextProps;
    const { itemCd, grpCd } = params;
    if (grpCd !== '') {
      this.getGrpInfo(grpCd);
    } else {
      this.getItemInfo(itemCd);
    }
  }

  getItemInfo(itemCd) {
    const { setNewParams } = this.props;

    if (itemCd !== '') {
      // propsで指定された汎用コードをキーに汎用レコードを得る
      axios.get(`/api/v1/requestitems/${itemCd}`)
        .then((res) => {
          // stateに格納することでrenderメソッドが呼び出される
          const itemName = res.data.requestname;
          this.setState({ ...this.state, itemName });
          setNewParams({ itemName });
        });
    } else {
      this.setState({ ...this.state, itemName: '' });
      setNewParams({ itemName: '' });
    }
  }

  getGrpInfo(grpCd) {
    const { setNewParams } = this.props;

    if (grpCd !== '') {
      // propsで指定された汎用コードをキーに汎用レコードを得る
      axios.get(`/api/v1/groups/${grpCd}`)
        .then((res) => {
          // stateに格納することでrenderメソッドが呼び出される
          const itemName = res.data.grpname;
          this.setState({ ...this.state, itemName });
          setNewParams({ itemName });
        });
    } else {
      this.setState({ ...this.state, itemName: '' });
      setNewParams({ itemName: '' });
    }
  }

  setItemInfo(selectedItem) {
    const { setNewParams } = this.props;
    if (selectedItem) {
      if (selectedItem.length > 0) {
        const item = selectedItem[0];
        const { tableDiv } = item;
        if (tableDiv && tableDiv !== 1) {
          setNewParams({ itemCd: '', grpCd: item.grpCd });
        } else {
          setNewParams({ itemCd: item.itemCd, grpCd: '' });
        }
      }
    } else {
      setNewParams({ itemCd: '', grpCd: '' });
    }
  }

  render() {
    const { itemName } = this.state;
    return (
      <div>
        <div style={{ width: '74px', float: 'left' }}>受診項目：</div>
        <div style={{ float: 'left' }}>
          <ItemAndGroupGuide setItemInfo={(selectedItem) => this.setItemInfo(selectedItem)} />
        </div>
        <div style={{ width: '200px', float: 'left' }}>
          {itemName !== '' &&
            (
              <Chip
                label={itemName}
                onDelete={() => {
                  this.setItemInfo(null);
                }}
              />
            )}
        </div>
      </div>
    );
  }
}

// propTypesの定義
DailyListItem.propTypes = {
  params: PropTypes.shape().isRequired,
  setNewParams: PropTypes.func.isRequired,
};

export default DailyListItem;
