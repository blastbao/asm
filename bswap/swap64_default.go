//go:build purego || !amd64
// +build purego !amd64

package bswap

import "encoding/binary"

func swap64(b []byte) {
	// 每 8B 转换一次
	for i := 0; i < len(b); i += 8 {
		// 大端 8B
		u := binary.BigEndian.Uint64(b[i:])
		// 小端 8B
		binary.LittleEndian.PutUint64(b[i:], u)
	}
}
